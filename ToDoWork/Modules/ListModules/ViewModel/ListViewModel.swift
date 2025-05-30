//
//  ListViewModel.swift
//  ToDoWork
//
//  Created by Drolllted on 27.05.2025.
//

import UIKit

final class ListViewModel {
    
    private var todos: [Todo] = []
    private let apiManager = APIManager.shared
    
    var onTodosUpdates: (() -> Void)?
    var errors: ((String) -> Void)?
    
    func fetchTodos() {
        apiManager.setupJSON { [weak self] result in
            switch result{
            case .success(let welcomeJSON):
                self?.todos = welcomeJSON.todos
                self?.onTodosUpdates?()
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
    
}
