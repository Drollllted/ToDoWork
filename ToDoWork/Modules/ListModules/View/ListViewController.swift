//
//  ViewController.swift
//  ToDoWork
//
//  Created by Drolllted on 27.05.2025.
//

import UIKit

final class ListViewController: UIViewController {
    
    weak var listCoordinatesDelegate: ListCoordinator?
    private var listView: ListView!
    private let viewModel = ListViewModel()
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func loadView() {
        listView = ListView()
        view = listView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupNavBar()
        delegateTableView()
        fetch()
        setupLongPressGesture()
        setupSearchController()
        setupTapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.listView.tableNoteView.reloadData()
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        title = "ToDoList"
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createNotes))
        navigationItem.rightBarButtonItem = addButton
        
        blackNavBarAtScroll()
        
    }
    
    func blackNavBarAtScroll() {
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.backgroundColor = .black
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            
            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
            navigationController?.navigationBar.compactAppearance = navBarAppearance
            
            navigationController?.navigationBar.tintColor = .white
            navigationController?.navigationBar.barStyle = .black
        }
    }
    private func fetch() {
        viewModel.fetchTodos()
        viewModel.fetchNotes()
        setupBinding()
    }
    
    private func delegateTableView() {
        listView.tableNoteView.delegate = self
        listView.tableNoteView.dataSource = self
    }
    
    private func setupBinding() {
        viewModel.onDataUpdates = { [weak self] in
            DispatchQueue.main.async {
                self?.listView.tableNoteView.reloadData()
            }
        }
        
        viewModel.errors = {[weak self] errorMessage in
            let alert = UIAlertController(title: "Warning", message: errorMessage, preferredStyle: .alert)
            _ = UIAlertAction(title: "Ok", style: .cancel)
            self?.present(alert, animated: true)
        }
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.searchTextField.textColor = .white
        
        let placeholderAttributes = [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        let attributedPlaceholder = NSAttributedString(string: "Search notes", attributes: placeholderAttributes)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = attributedPlaceholder
        
        if let searchIcon = searchController.searchBar.searchTextField.leftView as? UIImageView {
            searchIcon.tintColor = .lightGray
        }
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupLongPressGesture() {
        let longPressRecognizer = UILongPressGestureRecognizer(
            target: self,
            action: #selector(handleLongPress(_:))
        )
        listView.tableNoteView.addGestureRecognizer(longPressRecognizer)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func createNotes() {
        print("ewqw")
        
        guard let navigationController = listCoordinatesDelegate?.navigationController else {return}
        
        let noteCoordinator = NoteCoordinator(navigationController: navigationController, note: nil, mode: .rework)
        noteCoordinator.start { [weak self] in
            self?.viewModel.fetchNotes()
            self?.listView.tableNoteView.reloadData()
        }
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.addAllItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListCell.id, for: indexPath) as? ListCell else {fatalError("Hi hi hi")}
        
        let item = viewModel.item(at: indexPath.row)
        
        cell.configure(with: item) { isCompleted in
            if var todo = item as? Todo {
                todo.completed = isCompleted
            } else if let note = item as? Note {
                note.completed = isCompleted
                try? CoreDataManager.shared.addOrUpdateNote(note: note)
                self.viewModel.fetchNotes()
            }
        }
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 106
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = viewModel.item(at: indexPath.row)
        
        if let todo = item as? Todo {
            let coordinator = NoteCoordinator(
                navigationController: navigationController ?? UINavigationController(),
                todo: todo
            )
            coordinator.start { [weak self] in
                self?.listView.tableNoteView.reloadData()
            }
        } else if let note = item as? Note {
            let coordinator = NoteCoordinator(
                navigationController: navigationController ?? UINavigationController(),
                note: note,
                mode: .notRework
            )
            coordinator.start { [weak self] in
                self?.viewModel.fetchNotes()
                self?.listView.tableNoteView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            
            let item = self.viewModel.item(at: indexPath.row)
            
            let editAction = UIAction(
                title: "Edit",
                image: UIImage(systemName: "pencil")
            ) { _ in
                if let note = item as? Note {
                    let noteCoordinator = NoteCoordinator(navigationController: self.navigationController!, note: note, mode: .rework)
                    noteCoordinator.start { [weak self] in
                        self?.viewModel.fetchNotes()
                        self?.listView.tableNoteView.reloadData()
                    }
                }
            }
            
            let shareAction = UIAction(
                title: "Share",
                image: UIImage(systemName: "square.and.arrow.up")
            ) { _ in
                if let todo = item as? Todo {
                    let textToShare = "Поделиться \(todo.todo)"
                    let activityVC = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
                    self.present(activityVC, animated: true)
                }else if let note = item as? Note {
                    let textToShare = "Поделиться \(String(describing: note.titleNotes))"
                    let activityVC = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
                    self.present(activityVC, animated: true)
                }
                
            }
            
            let deleteAction = UIAction(
                title: "Delete",
                image: UIImage(systemName: "trash"),
                attributes: .destructive
            ) { [weak self] _ in
                
                let alertController = UIAlertController(title: "Delete", message: "Are you sure?", preferredStyle: .alert)
                
                let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
                    self?.viewModel.deleteItem(at: indexPath.row) { success in
                        DispatchQueue.main.async {
                            if success{
                                tableView.deleteRows(at: [indexPath], with: .automatic)
                            }
                        }
                    }
                }
                let cancelButton = UIAlertAction(title: "Cancel", style: .default) { _ in
                    
                }
                
                alertController.addAction(deleteAction)
                alertController.addAction(cancelButton)
                
                self?.present(alertController, animated: true)
                
            }
            return UIMenu(title: "", children: [editAction, shareAction, deleteAction])
        }
    }
    
    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        print("231")
    }
    
}
extension ListViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {return}
        viewModel.filterContentForSearchText(searchText)
    }
    
}

extension ListViewController: UISearchControllerDelegate {
    func didDismissSearchController(_ searchController: UISearchController) {
        viewModel.isSearching = false
    }
}
