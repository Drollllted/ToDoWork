//
//  ViewController.swift
//  ToDoWork
//
//  Created by Drolllted on 27.05.2025.
//

import UIKit

class ListViewController: UIViewController {
    
    weak var listCoordinatesDelegate: ListCoordinator?
    private var listView: ListView!
    
    override func loadView() {
        listView = ListView()
        view = listView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupNavBar()
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "ToDoList"
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    }


}

