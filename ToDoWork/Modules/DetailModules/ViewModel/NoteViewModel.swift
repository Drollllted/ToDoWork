//
//  NoteViewModel.swift
//  ToDoWork
//
//  Created by Drolllted on 27.05.2025.
//

import UIKit

enum NoteType {
    case coreData(note: Note)
    case api(todo: Todo)
}

final class NoteViewModel {
    
    private var noteType: NoteType
    private let coreDataManager = CoreDataManager.shared
    
    var onUpdate: (() -> Void)?
    
    var isReadOnly: Bool {
        if case .api(_) = noteType {
            return true
        }
        return false
    }
    
    var title: String {
        switch noteType {
        case .coreData(let note):
            return note.titleNotes ?? ""
        case .api(let todo):
            return todo.todo
        }
    }
    
    var textView: String {
        switch noteType {
        case .coreData(let note):
            return note.textNotes ?? ""
        case .api(_):
            return "From API(Note Write, Only Read)"
        }
    }
    
    var date: String{
        switch noteType {
        case .coreData(let note):
            guard let date = note.dateNotes else {return ""}
            return DateFormatterHelper.shared.formattedDate(from: date)
        case .api(_):
            return "20/05/2025"
        }
    }
    
    init(noteType: NoteType) {
        self.noteType = noteType
    }
    
    func updateNotes(title: String, text: String) {
        guard case .coreData(let note) = noteType else {
            return
        }
        note.titleNotes = title
        note.textNotes = text
        
        do {
            try coreDataManager.addOrUpdateNote(note: note)
            coreDataManager.saveContext()
        } catch {
            print("Error with viewModel: \(error.localizedDescription)")
        }
    }
    
}
