//
//  NoteViewController.swift
//  ToDoWork
//
//  Created by Drolllted on 27.05.2025.
//

import UIKit

final class NoteViewController: UIViewController {
    private var noteView: NoteView!
    weak var noteCoordinator: NoteCoordinator?
    var viewModel: NoteViewModel!
    var onSave: (() -> Void)?
    
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
        
        let saveButton = UIBarButtonItem(
            image: UIImage(systemName: "checkmark"),
            style: .done,
            target: self,
            action: #selector(saveNote)
        )
        navigationItem.rightBarButtonItem = saveButton
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
