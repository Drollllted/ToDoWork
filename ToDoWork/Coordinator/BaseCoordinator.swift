//
//  BaseCoordinator.swift
//  ToDoWork
//
//  Created by Drolllted on 27.05.2025.
//

import UIKit

class BaseCoordinator: Coordinator {
    var childrenCoordinator: [any Coordinator] = []
    
    func start() {
        fatalError("Ops, What's Wrong?")
    }
    
    
}
