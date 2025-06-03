//
//  NoteViewModel.swift
//  ToDoWork
//
//  Created by Drolllted on 27.05.2025.
//

import UIKit

final class NoteViewModel {
    let note: Note?
    var todo: Todo?
    private let coreDataManager = CoreDataManager.shared
    
    var onUpdate: (() -> Void)?
    
    var title: String {
        note?.titleNotes ?? ""
    }
    
    var text: String {
        note?.textNotes ?? ""
    }
    
    var date: String {
        DateFormatterHelper.shared.formattedDate(from: note?.dateNotes ?? Date())
    }
    
    init(note: Note) {
        self.note = note
        self.todo = nil
    }
    
    init(todo: Todo) {
        self.todo = todo
        self.note = nil
    }
    
    func updateNote(title: String, text: String) {
        note?.titleNotes = title
        note?.textNotes = text
        note?.dateNotes = Date()
        
        do {
            try coreDataManager.addOrUpdateNote(note: note!)
            coreDataManager.saveContext()
            onUpdate?()
        } catch {
            print("Error saving note: \(error.localizedDescription)")
        }
    }
    

}
