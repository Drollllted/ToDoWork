//
//  NoteView.swift
//  ToDoWork
//
//  Created by Drolllted on 27.05.2025.
//

import UIKit

final class NoteView: UIView {
    
    lazy var nameNoteTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name Note"
        tf.font = .systemFont(ofSize: 30, weight: .bold)
        tf.textColor = .white
        tf.borderStyle = .line
        tf.attributedPlaceholder = NSAttributedString(string: tf.placeholder ?? "No Name", attributes: [.foregroundColor : UIColor.lightGray])
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        
        return tf
    }()
    
    lazy var dateCreateNote: UILabel = {
        let label = UILabel()
        label.text = "20/05/2025"
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var stackNameAndDateCreateNote: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 5
        stack.alignment = .leading
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(nameNoteTextField)
        stack.addArrangedSubview(dateCreateNote)
        
        return stack
    }()
    
    lazy var textViewNote: UITextView = {
        let textView = UITextView()
        textView.attributedText = NSAttributedString(string: textView.text ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        textView.font = .systemFont(ofSize: 18, weight: .semibold)
        textView.keyboardType = .default
        textView.textColor = .white
        textView.backgroundColor = .black
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
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
extension NoteView {
    
    func setupUI(){
        addSubview(stackNameAndDateCreateNote)
        addSubview(textViewNote)
    }
    
    func constraintsUI() {
        NSLayoutConstraint.activate([
            
            nameNoteTextField.heightAnchor.constraint(equalToConstant: 41),
            stackNameAndDateCreateNote.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            stackNameAndDateCreateNote.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            stackNameAndDateCreateNote.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 30),
            stackNameAndDateCreateNote.heightAnchor.constraint(equalToConstant: 100),
            
            textViewNote.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            textViewNote.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            textViewNote.topAnchor.constraint(equalTo: stackNameAndDateCreateNote.bottomAnchor, constant: 5),
            textViewNote.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -5)
        ])
    }
    
}
