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
    
    private var filteredItems: [Any] = []
    var isSearching = false
    
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
        if isSearching {
            guard index < filteredItems.count else {
                fatalError("Index out of range")
            }
            return filteredItems[index]
        } else {
            let allItems = getAllItems()
            guard index < allItems.count else {
                fatalError("Index out of range")
            }
            return allItems[index]
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
    
    func deleteItem(at index: Int, completion: @escaping (Bool) -> Void) {
        let allItems = getAllItems()
        guard index < allItems.count else {
            completion(false)
            return
        }

        let item = allItems[index]
        
        if let todo = item as? Todo {
            if let todoIndex = todos.firstIndex(where: { $0.id == todo.id }) {
                todos.remove(at: todoIndex)
                completion(true)
            } else {
                completion(false)
            }
        } else if let note = item as? Note {
            guard let id = note.id else {
                completion(false)
                return
            }
            
            do {
                try coreDataManager.deleteNotes(id: id)
                try coreDataManager.getNotes()
                notes = coreDataManager.notes.sorted { note1, note2 in
                    (note1.dateNotes ?? Date()) > (note2.dateNotes ?? Date())
                }
                completion(true)
            } catch {
                errors?(error.localizedDescription)
                completion(false)
            }
        } else {
            completion(false)
        }
        
        onDataUpdates?()
    }
    
    //MARK: Count All
    
    func addAllItems() -> Int {
        return isSearching ? filteredItems.count : getAllItems().count
    }
    
    //MARK: - Filters
    
    private func getAllItems() -> [Any] {
        var getItems: [Any] = []
        getItems += todos
        getItems += notes
        
        return sortedItemsByDates(items: getItems)
    }
    func filterContentForSearchText(_ searchText: String) {
        let searchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        if searchText.isEmpty {
            isSearching = false
            onDataUpdates?()
            return
        }
        
        isSearching = true
        let allItems = getAllItems()
        
        filteredItems = allItems.filter { item in
            if let todo = item as? Todo {
                return todo.todo.lowercased().contains(searchText)
            } else if let note = item as? Note {
                let titleContains = note.titleNotes?.lowercased().contains(searchText) ?? false
                let textContains = note.textNotes?.lowercased().contains(searchText) ?? false
                return titleContains || textContains
            }
            return false
        }
        
        onDataUpdates?()
    }
    
    //MARK: - Sorted TableView
    
    func sortedItemsByDates(items: [Any]) -> [Any] {
        return items.sorted { item1, item2 in
            let date1: Date
            let date2: Date
            
            if item1 is Todo {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                date1 = dateFormatter.date(from: "20/05/2025") ?? Date()
            } else if let note1 = item1 as? Note {
                date1 = note1.dateNotes ?? Date()
            } else {
                date1 = Date()
            }
            
            if item2 is Todo {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                date2 = dateFormatter.date(from: "20/05/2025") ?? Date()
            } else if let note2 = item2 as? Note {
                date2 = note2.dateNotes ?? Date()
            } else {
                date2 = Date()
            }
            
            return date1 > date2
        }
    }
}
