//
//  ListCoordinator.swift
//  ToDoWork
//
//  Created by Drolllted on 27.05.2025.
//

import UIKit

class ListCoordinator: BaseCoordinator{
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() {
        let listVC = ListViewController()
        listVC.listCoordinatesDelegate = self
        self.navigationController.pushViewController(listVC, animated: true)
    }
}
