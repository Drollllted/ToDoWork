//
//  NoteCoordinator.swift
//  ToDoWork
//
//  Created by Drolllted on 01.06.2025.
//

import UIKit

class NoteCoordinator: BaseCoordinator {
    
    private let navigationController: UINavigationController
    private let note: Note?
    private let todo: Todo?
    private var onFinish: (() -> Void)?
    private let mode: Rework
    
    init(navigationController: UINavigationController, note: Note?, mode: Rework = .rework) {
        self.navigationController = navigationController
        self.note = note
        self.todo = nil
        self.mode = mode
    }
    
    init(navigationController: UINavigationController, todo: Todo) {
        self.navigationController = navigationController
        self.todo = todo
        self.note = nil
        self.mode = .viewOnly
    }
    
    func start(completion: @escaping () -> Void) {
        self.onFinish = completion
        if let todo = todo {
            let noteVC = NoteViewController(reworkEnum: mode)
            noteVC.viewModel = NoteViewModel(todo: todo)
            noteVC.noteCoordinator = self
            navigationController.pushViewController(noteVC, animated: true)
        } else {
            let noteToEdit = note ?? CoreDataManager.shared.createNewNote()
            let noteVC = NoteViewController(reworkEnum: mode)
            noteVC.viewModel = NoteViewModel(note: noteToEdit)
            noteVC.noteCoordinator = self
            noteVC.onSave = { [weak self] in
                completion()
                self?.navigationController.popViewController(animated: true)
            }
            navigationController.pushViewController(noteVC, animated: true)
        }
    }
    
    func dismiss() {
        navigationController.popViewController(animated: true)
    }
}
