//
//  WelcomeJSON.swift
//  ToDoWork
//
//  Created by Drolllted on 29.05.2025.
//

import Foundation

struct WelcomeJSON: Codable {
    let todos: [Todo]
    let total, skip, limit: Int
}

// MARK: - Todo
struct Todo: Codable {
    let id: Int
    let todo: String
    var completed: Bool
    let userId: Int
}
