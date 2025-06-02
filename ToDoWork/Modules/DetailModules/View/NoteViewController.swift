//
//  NoteViewController.swift
//  ToDoWork
//
//  Created by Drolllted on 27.05.2025.
//

import UIKit

final class NoteViewController: UIViewController{
    
    private var noteView: NoteView!
    var note: Note?
    weak var noteCoordinator: NoteCoordinator?
    var viewModel: NoteViewModel!
    
    override func loadView() {
        noteView = NoteView()
        view = noteView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupNavBar()
        readOnlyForAPI()
        setupBindings()
        configureUI()
    }
    
    private func setupNavBar() {
        self.navigationItem.title = "Note"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func readOnlyForAPI() {
        noteView.nameNoteTextField.isEnabled = !viewModel.isReadOnly
        noteView.textViewNote.isEditable = !viewModel.isReadOnly
        
        if viewModel.isReadOnly {
            noteView.nameNoteTextField.textColor = .lightGray
            noteView.textViewNote.textColor = .lightGray
            noteView.nameNoteTextField.backgroundColor = .darkGray.withAlphaComponent(0.2)
            noteView.textViewNote.backgroundColor = .darkGray.withAlphaComponent(0.2)
        }
    }
    
    private func setupBindings() {
        viewModel.onUpdate = { [weak self] in
            self?.configureUI()
        }
    }
    private func configureUI() {
        noteView.nameNoteTextField.text = viewModel.title
        noteView.textViewNote.text = viewModel.textView
        noteView.dateCreateNote.text = viewModel.date
    }
    
    @objc private func saveNote() {
        viewModel.updateNotes(title: noteView.nameNoteTextField.text ?? "",
                              text: noteView.textViewNote.text)
        navigationController?.popViewController(animated: true)
    }
    
    
    
}
