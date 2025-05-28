//
//  ListCell.swift
//  ToDoWork
//
//  Created by Drolllted on 28.05.2025.
//

import UIKit

final class ListCell: UITableViewCell {
    
    static let id = "Id"
    
    lazy var completeButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.orange.cgColor
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var nameNote: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        constraintsUI()
        setupCell()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        self.backgroundColor = .black
        self.layer.cornerRadius = 15
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.blue.cgColor
    }
    
}
extension ListCell {
    
    func setupUI(){
        addSubview(completeButton)
    }
    
    func constraintsUI() {
        NSLayoutConstraint.activate([
            completeButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            completeButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            completeButton.heightAnchor.constraint(equalToConstant: 30),
            completeButton.widthAnchor.constraint(equalToConstant: 30),
        ])
    }
    
}
