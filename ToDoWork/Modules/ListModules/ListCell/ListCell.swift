//
//  ListCell.swift
//  ToDoWork
//
//  Created by Drolllted on 28.05.2025.
//

import UIKit

final class ListCell: UITableViewCell {
    
    static let id = "Id"
    
    var completionHandler: ((Bool) -> Void)?
    
    var isCompleted: Bool = false
    
    lazy var completeButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.orange.cgColor
        
        button.addTarget(self, action: #selector(tapInButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.isUserInteractionEnabled = true
        
        return button
    }()
    
    lazy var nameNoteLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.text = "NoteText"
        label.textColor = .white
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var secondaryNoteLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.text = "Note Note Note Note Note Note Note Note Note Note Note Note Note Note Note Note Note Note Note Note"
        label.numberOfLines = 2
        label.textColor = .lightGray
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var dateCreateNoteLabel: UILabel = {
        let label = UILabel()
        label.text = "20/02/25"
        label.textColor = .gray
        label.font = .systemFont(ofSize: 14, weight: .light)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var stackNote: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.alignment = .leading
        
        stack.isUserInteractionEnabled = true
        
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(nameNoteLabel)
        stack.addArrangedSubview(secondaryNoteLabel)
        stack.addArrangedSubview(dateCreateNoteLabel)
        
        return stack
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
        backgroundColor = .black
        contentView.backgroundColor = .black
        contentView.layer.cornerRadius = 15
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.blue.cgColor
    }
    
    //MARK: - Action Button
    
    @objc private func tapInButton() {
        let newState = !(completeButton.image(for: .normal) != nil)
        updateAppearance(isCompleted: newState)
        completionHandler?(newState)
    }
    
    //MARK: - Configure
    
    func configure(with model: Any, completion: @escaping (Bool) -> Void){
        self.completionHandler = completion
        
        if let todo = model as? Todo {
            nameNoteLabel.text = todo.todo
            secondaryNoteLabel.text = "From API"
            dateCreateNoteLabel.text = "20/05/2025"
            updateAppearance(isCompleted: todo.completed)
        } else if let note = model as? Note {
            nameNoteLabel.text = note.titleNotes
            secondaryNoteLabel.text = note.textNotes
            dateCreateNoteLabel.text = DateFormatterHelper.shared.formattedDate(from: note.dateNotes ?? Date())
            updateAppearance(isCompleted: note.completed)
        }
    }
    
    private func updateAppearance(isCompleted: Bool) {
        if isCompleted{
            applyCompletedStyle()
        }else {
            applyDefaultStyle()
        }
    }
    
    private func applyCompletedStyle() {
        let strikeAttributes: [NSAttributedString.Key: Any] = [
            .strikethroughStyle: NSUnderlineStyle.single.rawValue,
            .strikethroughColor: UIColor.gray,
            .foregroundColor: UIColor.gray
        ]
        
        nameNoteLabel.attributedText = NSAttributedString(
            string: nameNoteLabel.text ?? "",
            attributes: strikeAttributes
        )
        
        secondaryNoteLabel.attributedText = NSAttributedString(
            string: secondaryNoteLabel.text ?? "",
            attributes: strikeAttributes
        )
        
        dateCreateNoteLabel.attributedText = NSAttributedString(
            string: dateCreateNoteLabel.text ?? "",
            attributes: strikeAttributes
        )
        
        completeButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
        completeButton.backgroundColor = .systemOrange
        secondaryNoteLabel.textColor = .darkGray
        dateCreateNoteLabel.textColor = .systemOrange
    }
    
    private func applyDefaultStyle() {
        let strikeAttributes: [NSAttributedString.Key: Any] = [
            .strikethroughStyle: NSUnderlineStyle.single.rawValue,
            .strikethroughColor: UIColor.clear,
            .foregroundColor: UIColor.clear
        ]
        
        nameNoteLabel.attributedText = NSAttributedString(
            string: nameNoteLabel.text ?? "",
            attributes: strikeAttributes
        )
        
        secondaryNoteLabel.attributedText = NSAttributedString(
            string: secondaryNoteLabel.text ?? "",
            attributes: strikeAttributes
        )
        
        dateCreateNoteLabel.attributedText = NSAttributedString(
            string: dateCreateNoteLabel.text ?? "",
            attributes: strikeAttributes
        )
        
        completeButton.setImage(nil, for: .normal)
        completeButton.backgroundColor = .clear
        nameNoteLabel.textColor = .white
        secondaryNoteLabel.textColor = .lightGray
        dateCreateNoteLabel.textColor = .gray
    }
}
extension ListCell {
    
    func setupUI(){
        contentView.addSubview(completeButton)
        contentView.addSubview(stackNote)

        contentView.isUserInteractionEnabled = true
        self.isUserInteractionEnabled = true
    }
    
    func constraintsUI() {
        NSLayoutConstraint.activate([
            completeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            completeButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            completeButton.widthAnchor.constraint(equalToConstant: 30),
            completeButton.heightAnchor.constraint(equalToConstant: 30),
            
            stackNote.leadingAnchor.constraint(equalTo: completeButton.trailingAnchor, constant: 15),
            stackNote.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            stackNote.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackNote.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
}
