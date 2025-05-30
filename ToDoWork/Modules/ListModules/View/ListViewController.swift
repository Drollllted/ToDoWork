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
        viewModel.fetchTodos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupBinding()
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "ToDoList"
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
    }
    
    private func delegateTableView() {
        listView.tableNoteView.delegate = self
        listView.tableNoteView.dataSource = self
    }
    
    private func setupBinding() {
        viewModel.onTodosUpdates = { [weak self] in
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


}

extension ListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.countOfTodos()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListCell.id, for: indexPath) as? ListCell else {fatalError("Hi hi hi")}
        
        let todo = viewModel.todo(at: indexPath.row)
        cell.configure(with: todo)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 106
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

