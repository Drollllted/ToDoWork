//
//  ListViewModel.swift
//  ToDoWork
//
//  Created by Drolllted on 27.05.2025.
//

import UIKit

final class ListViewModel {
    
    private var todos: [Todo] = []
    private var notes: [Note] = []
    private let apiManager = APIManager.shared
    private let coreDataManager = CoreDataManager.shared
    
    var onDataUpdates: (() -> Void)?
    var errors: ((String) -> Void)?
    
    //MARK: - For API
    
    func fetchTodos() {
        apiManager.setupJSON { [weak self] result in
            switch result{
            case .success(let welcomeJSON):
                self?.todos = welcomeJSON.todos
                self?.onDataUpdates?()
            case .failure(let error):
                self?.errors?(error.localizedDescription)
            }
        }
    }
    
    func countOfTodos() -> Int {
        return todos.count
    }
    
    func todo(at index: Int) -> Todo {
        return todos[index]
    }
    
    //MARK: - For Core Data
    
    func fetchNotes() {
        do{
            try coreDataManager.getNotes()
            notes = coreDataManager.notes
            onDataUpdates?()
        } catch {
            errors?(error.localizedDescription)
        }
    }
    
    func item(at index: Int) -> Any {
        if index < todos.count {
            return todos[index]
        } else {
            return notes[index - todos.count]
        }
    }
    
    func toggleCompleted(at index: Int) {
         if index < todos.count {
             todos[index].completed.toggle()
         } else {
             let noteIndex = index - todos.count
             let note = notes[noteIndex]
             note.completed.toggle()
             do {
                 try coreDataManager.addOrUpdateNote(note: note)
                 try coreDataManager.getNotes()
             } catch {
                 errors?(error.localizedDescription)
             }
         }
         onDataUpdates?()
     }
     
     func deleteItem(at index: Int) {
         if index < todos.count {
             todos.remove(at: index)
         } else {
             let noteIndex = index - todos.count
             let note = notes[noteIndex]
             if let id = note.id {
                 do {
                     try coreDataManager.deleteNotes(id: id)
                     notes.remove(at: noteIndex)
                 } catch {
                     errors?(error.localizedDescription)
                 }
             }
         }
         onDataUpdates?()
     }
    
    //MARK: Count All
    
    func addAllItems() -> Int {
        return todos.count + notes.count
    }
    
}
