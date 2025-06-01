//
//  NoteCoordinator.swift
//  ToDoWork
//
//  Created by Drolllted on 01.06.2025.
//

import UIKit

class NoteCoordinator: BaseCoordinator{
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() {
        let noteViewController = NoteViewController()
        noteViewController.noteCoordinator = self
        self.navigationController.pushViewController(noteViewController, animated: true)
    }
    
    func dismiss() {
        navigationController.dismiss(animated: true)
    }
    
}
