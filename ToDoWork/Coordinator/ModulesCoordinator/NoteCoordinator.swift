//
//  NoteCoordinator.swift
//  ToDoWork
//
//  Created by Drolllted on 01.06.2025.
//

import UIKit

class NoteCoordinator: BaseCoordinator{
    
    private let navigationController: UINavigationController
    private let note: Note?
    private var onFinish: (() -> Void)?
    
    init(navigationController: UINavigationController, note: Note?) {
        self.navigationController = navigationController
        self.note = note
    }
    
    func start(completion: @escaping () -> Void) {
        self.onFinish = completion
        let noteVC = NoteViewController()
        let noteToEdit = note ?? CoreDataManager.shared.createNewNote()
        
        noteVC.viewModel = NoteViewModel(note: noteToEdit)
        noteVC.noteCoordinator = self
        noteVC.onSave = { [weak self] in
            self?.onFinish?()
        }
        
        navigationController.pushViewController(noteVC, animated: true)
    }
    
    func dismiss() {
        navigationController.popViewController(animated: true)
        onFinish?()
    }
    
}
