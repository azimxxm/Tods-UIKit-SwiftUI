//
//  UsersCell.swift
//  Tods
//
//  Created by Azimjon Abdurasulov on 20/08/25.
//


import UIKit

final class UsersCell: UITableViewCell {
    static let identifier = "UsersCell"
    
    private let idLabel = UILabel()
    private let nameLabel = UILabel()
    private let emailLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        idLabel.font = .boldSystemFont(ofSize: 14)
        nameLabel.font = .systemFont(ofSize: 16)
        nameLabel.numberOfLines = 0
        emailLabel.font = .systemFont(ofSize: 14)
        emailLabel.textColor = .secondaryLabel
        
        let stack = UIStackView(arrangedSubviews: [idLabel, nameLabel, emailLabel])
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
    
    func configure(with user: User) {
        idLabel.text = "ID: \(user.id)"
        nameLabel.text = "Name: \(user.name)"
        emailLabel.text = "Email: \(user.email)"
    }
}