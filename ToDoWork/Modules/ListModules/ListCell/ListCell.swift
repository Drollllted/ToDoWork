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
    
    lazy var completeButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.orange.cgColor
        
        button.addTarget(self, action: #selector(tapInButton), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
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
        self.backgroundColor = .black
        self.layer.cornerRadius = 15
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.blue.cgColor
    }
    
    //MARK: - Action Button
    
    @objc func tapInButton() {
        
    }
    
    //MARK: - Configure
    
    func configureTodos(with todo: Todo) {
        nameNoteLabel.text = todo.todo
        secondaryNoteLabel.text = "From API"
        dateCreateNoteLabel.text = "20/05/2025"
        
        if todo.completed {
            applyCompletedStyle()
        } else {
            applyDefaultStyle()
        }
    }
    
    func configureNotes(with note: Note) {
        nameNoteLabel.text = note.titleNotes ?? "No title"
        secondaryNoteLabel.text = note.textNotes ?? "No description"
        dateCreateNoteLabel.text = DateFormatterHelper.shared.formattedDate(from: note.dateNotes ?? Date())
        
        if note.completed {
            applyCompletedStyle()
        } else {
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
        addSubview(completeButton)
        addSubview(stackNote)
    }
    
    func constraintsUI() {
        NSLayoutConstraint.activate([
            completeButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            completeButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            completeButton.heightAnchor.constraint(equalToConstant: 30),
            completeButton.widthAnchor.constraint(equalToConstant: 30),
            
            stackNote.leadingAnchor.constraint(equalTo: completeButton.trailingAnchor, constant: 15),
            stackNote.topAnchor.constraint(equalTo: self.topAnchor, constant: 2),
            stackNote.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            stackNote.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5)
        ])
    }
    
}
