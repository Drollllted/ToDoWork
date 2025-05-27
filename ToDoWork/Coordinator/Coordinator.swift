//
//  Coordinator.swift
//  ToDoWork
//
//  Created by Drolllted on 27.05.2025.
//

import UIKit

protocol Coordinator: AnyObject {
    var childrenCoordinator: [Coordinator] {get set}
    func start()
}


extension Coordinator{
    func add(coordinator: Coordinator) {
        childrenCoordinator.append(coordinator)
    }
    
    func remote(coordinator: Coordinator) {
        childrenCoordinator = childrenCoordinator.filter({$0 !== coordinator})
    }
}
