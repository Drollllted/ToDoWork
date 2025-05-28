//
//  ListView.swift
//  ToDoWork
//
//  Created by Drolllted on 27.05.2025.
//

import UIKit


final class ListView: UIView {
    
    lazy var tableNoteView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .black
        tv.register(ListCell.self, forCellReuseIdentifier: ListCell.id)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
        constraintsUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension ListView {
    func setupUI(){
        addSubview(tableNoteView)
    }
    
    func constraintsUI() {
        NSLayoutConstraint.activate([
            tableNoteView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableNoteView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableNoteView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10),
            tableNoteView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
}
