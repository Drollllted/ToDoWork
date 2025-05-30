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
    
    private let apiCaller = APIManager.shared
    
    override func loadView() {
        listView = ListView()
        view = listView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupNavBar()
        delegateTableView()
        apiCaller.setupJSON()
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


}

extension ListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListCell.id, for: indexPath) as? ListCell else {fatalError("Hi hi hi")}
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 106
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

