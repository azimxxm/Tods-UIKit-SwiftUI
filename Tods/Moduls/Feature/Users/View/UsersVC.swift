//
//  UsersVC.swift
//  Tods
//
//  Created by Azimjon Abdurasulov on 20/08/25.
//

import UIKit

final class UsersVC: UIViewController {
    
    private let viewModel = UsersViewModel()
    private let tableView = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Feature"
        view.backgroundColor = .systemBackground
        setupTableView()
        setupSearch()
        fetchUsers()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UsersCell.self, forCellReuseIdentifier: UsersCell.identifier)
    }
    
    private func setupSearch() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Users by name"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func fetchUsers() {
        Task {
            await viewModel.fetchUsers()
            tableView.reloadData()
        }
    }
}

extension UsersVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UsersCell.identifier, for: indexPath) as? UsersCell else {
            return UITableViewCell()
        }
        if let user = viewModel.user(at: indexPath.row) {
            cell.configure(with: user)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let user = viewModel.user(at: indexPath.row) {
            let detailVC = UserDetailVC(user: user)
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

// MARK: - UISearchResultsUpdating
extension UsersVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.filter(by: searchController.searchBar.text)
        tableView.reloadData()
    }
}
