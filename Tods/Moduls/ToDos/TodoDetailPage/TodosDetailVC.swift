//
//  TodosDetailVC.swift
//  Tods
//
//  Created by Azimjon Abdurasulov on 20/08/25.
//
import UIKit

final class TodosDetailVC: UIViewController {
    
    private let todo: Todo
    private let user: User
    
    init(todo: Todo, user: User) {
        self.todo = todo
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let titleLabel = UILabel()
    private let completedLabel = UILabel()
    private let userInfoLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Todo Detail"
        
        setupUI()
        configureData()
    }
    
    private func setupUI() {
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.numberOfLines = 0
        
        completedLabel.font = .systemFont(ofSize: 16)
        
        userInfoLabel.font = .systemFont(ofSize: 16)
        userInfoLabel.numberOfLines = 0
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, completedLabel, userInfoLabel])
        stack.axis = .vertical
        stack.spacing = 12
        
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func configureData() {
        titleLabel.text = "Title: \(todo.title)"
        completedLabel.text = "Completed: \(todo.completed ? "✅ Yes" : "❌ No")"
        userInfoLabel.text = """
        User:
        Name: \(user.name)
        Username: \(user.username)
        Email: \(user.email)
        """
    }
}
