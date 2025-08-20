//
//  UsersVC.swift
//  Tods
//
//  Created by Azimjon Abdurasulov on 20/08/25.
//

import UIKit

class UsersVC: UIViewController {
    
    private var users: [User] = []
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Feature"
        view.backgroundColor = .systemBackground
        setupTableView()
        fetchUsers()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UsersCell.self, forCellReuseIdentifier: UsersCell.identifier)
    }
    
    private func fetchUsers() {
        Task {
            do {
                let fetchedUsers: [User] = try await NetworkManager.shared.getUsers()
                self.users = fetchedUsers
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print("❌ Error fetching users: \(error)")
            }
        }
    }
}

extension UsersVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UsersCell.identifier, for: indexPath) as? UsersCell else {
            return UITableViewCell()
        }
        let user = users[indexPath.row]
        cell.configure(with: user)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        let detailVC = UserDetailVC(user: user)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}




