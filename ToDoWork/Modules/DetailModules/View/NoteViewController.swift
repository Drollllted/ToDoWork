//
//  NoteViewController.swift
//  ToDoWork
//
//  Created by Drolllted on 27.05.2025.
//

import UIKit

enum Rework {
    case rework
    case notRework
    case viewOnly
}

final class NoteViewController: UIViewController {
    
    private var noteView: NoteView!
    weak var noteCoordinator: NoteCoordinator?
    var viewModel: NoteViewModel!
    var onSave: (() -> Void)?
    
    var reworkEnum: Rework
    
    init(reworkEnum: Rework) {
        self.reworkEnum = reworkEnum
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        noteView = NoteView()
        view = noteView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupNavBar()
        setupBindings()
        configureUI()
    }
    
    private func setupNavBar() {
        navigationItem.title = "Note"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.prefersLargeTitles = false
        
        switch reworkEnum {
        case .rework:
            let saveButton = UIBarButtonItem(
                image: UIImage(systemName: "checkmark"),
                style: .done,
                target: self,
                action: #selector(saveNote)
            )
            navigationItem.rightBarButtonItem = saveButton
            
            noteView.nameNoteTextField.isEnabled = true
            noteView.textViewNote.isEditable = true
            noteView.dateCreateNote.isEnabled = true
            
        case .notRework:
            noteView.nameNoteTextField.isEnabled = false
            noteView.textViewNote.isEditable = false
            noteView.dateCreateNote.isEnabled = false
            
        case .viewOnly:
            noteView.nameNoteTextField.isEnabled = false
            noteView.textViewNote.isEditable = false
            noteView.dateCreateNote.isEnabled = false
        }
    }
    
    private func setupBindings() {
        viewModel.onUpdate = { [weak self] in
            self?.noteCoordinator?.dismiss()
        }
    }
    
    private func configureUI() {
        noteView.nameNoteTextField.text = viewModel.title
        noteView.textViewNote.text = viewModel.text
        noteView.dateCreateNote.text = viewModel.date
    }
    
    @objc private func saveNote() {
        viewModel.updateNote(
            title: noteView.nameNoteTextField.text ?? "",
            text: noteView.textViewNote.text
        )
        onSave?()
        noteCoordinator?.dismiss()

    }
}
