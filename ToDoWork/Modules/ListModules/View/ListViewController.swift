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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.listView.tableNoteView.reloadData()
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "ToDoList"
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createNotes))
        navigationItem.rightBarButtonItem = addButton
        
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
            let alertAction = UIAlertAction(title: "Ok", style: .cancel)
            self?.present(alert, animated: true)
        }
    }
    
    @objc private func createNotes() {
        let alertController = UIAlertController(title: "Create new note", message: "What's title?", preferredStyle: .alert)
        alertController.addTextField { tf in
            tf.placeholder = "Title"
        }
        
        alertController.addTextField { tf in
            tf.placeholder = "Note"
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            guard let title = alertController.textFields?.first?.text,
                  let description = alertController.textFields?.last?.text else { return }
            
            let context = CoreDataManager.shared.persistentContainer.viewContext
            let newNote = Note(context: context)
            newNote.id = UUID()
            newNote.titleNotes = title
            newNote.textNotes = description
            newNote.dateNotes = Date()
            newNote.completed = false
            
            do {
                try CoreDataManager.shared.addOrUpdateNote(note: newNote)
                self?.viewModel.fetchNotes()
                self?.viewModel.fetchTodos()
                DispatchQueue.main.async { [weak self] in
                    self?.listView.tableNoteView.reloadData()
                }
            } catch {
                self?.viewModel.errors?(error.localizedDescription)
            }
        })
        
        present(alertController, animated: true)
        
        
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
        
        if let note = item as? Note {
            let noteViewModel = NoteViewModel(noteType: .coreData(note: note))
            listCoordinatesDelegate?.goToNoteVC(with: noteViewModel)
        } else if let todo = item as? Todo {
            let noteViewModel = NoteViewModel(noteType: .api(todo: todo))
            listCoordinatesDelegate?.goToNoteVC(with: noteViewModel)
            
        }
        
    }
    
}

