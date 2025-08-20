//
//  TodoCell.swift
//  Tods
//
//  Created by Azimjon Abdurasulov on 20/08/25.
//


import UIKit

final class TodoCell: UITableViewCell {
    static let identifier = "TodoCell"
    
    private let idLabel = UILabel()
    private let titleLabel = UILabel()
    private let completedLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        idLabel.font = .boldSystemFont(ofSize: 14)
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.numberOfLines = 0
        completedLabel.font = .systemFont(ofSize: 14)
        completedLabel.textColor = .secondaryLabel
        
        let stack = UIStackView(arrangedSubviews: [idLabel, titleLabel, completedLabel])
        stack.axis = .vertical
        stack.spacing = 4
        
        contentView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func configure(with todo: Todo) {
        idLabel.text = "ID: \(todo.id)"
//        idLabel.text = "ID: \(todo.id) | UserID: \(todo.userId)"
        titleLabel.text = "Title: \(todo.title)"
        completedLabel.text = "Completed: \(todo.completed ? "✅ Yes" : "❌ No")"
    }
}

