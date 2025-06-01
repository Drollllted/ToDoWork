//
//  NoteViewController.swift
//  ToDoWork
//
//  Created by Drolllted on 27.05.2025.
//

import UIKit

final class NoteViewController: UIViewController{
    
    private var noteView: NoteView!
    weak var noteCoordinator: NoteCoordinator?
    
    override func loadView() {
        noteView = NoteView()
        view = noteView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupNavBar()
    }
    
    private func setupNavBar() {
        self.navigationItem.title = "Note"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    
    
}
