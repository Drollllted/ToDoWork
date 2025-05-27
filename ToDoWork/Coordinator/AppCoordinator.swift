//
//  AppCoordinator.swift
//  ToDoWork
//
//  Created by Drolllted on 27.05.2025.
//

import UIKit

class AppCoordinator: BaseCoordinator{
    private var window: UIWindow
    
    private let navigationController: UINavigationController = {
        let nav = UINavigationController()
        nav.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        nav.navigationBar.prefersLargeTitles = true
        
        return nav
    }()
    
    init(window: UIWindow) {
        self.window = window
        self.window.rootViewController = navigationController
        self.window.makeKeyAndVisible()
    }
    
    override func start() {
        let listViewCoordinator = ListCoordinator(navigationController: navigationController)
        add(coordinator: listViewCoordinator)
        listViewCoordinator.start()
    }
}
