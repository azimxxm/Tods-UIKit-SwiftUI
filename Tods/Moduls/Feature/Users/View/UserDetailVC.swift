//
//  UserDetailVC.swift
//  Tods
//
//  Created by Azimjon Abdurasulov on 20/08/25.
//

import UIKit

final class UserDetailVC: UIViewController {
    
    private let user: User
    
    // MARK: - UI Elements
    private let scrollView = UIScrollView()
    private let contentView = UIStackView()
    private let todosButton = UIButton(type: .system)
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "User Detail"
        
        setupUI()
        populateData()
        setupTodosButton()
    }
    
    private func setupUI() {
        // ScrollView
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // ContentView (StackView)
        contentView.axis = .vertical
        contentView.spacing = 12
        contentView.alignment = .leading
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])
    }
    
    private func populateData() {
        addLabel(title: "Name", value: user.name)
        addLabel(title: "Username", value: user.username)
        addLabel(title: "Email", value: user.email)
        addLabel(title: "Phone", value: user.phone)
        addLabel(title: "Website", value: user.website)
        
        // Address
        let address = "\(user.address.street), \(user.address.suite), \(user.address.city), \(user.address.zipcode)"
        addLabel(title: "Address", value: address)
        
        let geo = "Lat: \(user.address.geo.lat), Lng: \(user.address.geo.lng)"
        addLabel(title: "Geo", value: geo)
        
        // Company
        addLabel(title: "Company", value: user.company.name)
        addLabel(title: "Catch Phrase", value: user.company.catchPhrase)
        addLabel(title: "Business", value: user.company.bs)
    }
    
    private func setupTodosButton() {
        todosButton.setTitle("View Todos", for: .normal)
        todosButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16) // kattaroq font
        todosButton.backgroundColor = .systemBlue
        todosButton.setTitleColor(.white, for: .normal)
        todosButton.layer.cornerRadius = 12
        todosButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        todosButton.addTarget(self, action: #selector(openTodos), for: .touchUpInside)

        var config = UIButton.Configuration.filled()
        config.title = "View Todos"
        config.baseBackgroundColor = .systemBlue
        config.baseForegroundColor = .white
        config.cornerStyle = .large
        config.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 28, bottom: 14, trailing: 28)
        
        todosButton.configuration = config

        todosButton.addTarget(self, action: #selector(openTodos), for: .touchUpInside)

        contentView.addArrangedSubview(todosButton)
        todosButton.translatesAutoresizingMaskIntoConstraints = false
    }

    
    @objc private func openTodos() {
        let todosVC = TodosByUserID(userId: user.id)
        navigationController?.pushViewController(todosVC, animated: true)
    }

    
    private func addLabel(title: String, value: String) {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "\(title): \(value)"
        label.font = UIFont.systemFont(ofSize: 16)
        contentView.addArrangedSubview(label)
    }
}








