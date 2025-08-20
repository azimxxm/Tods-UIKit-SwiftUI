//
//  TodosVC.swift
//  Tods
//
//  Created by Azimjon Abdurasulov on 20/08/25.

import UIKit

final class TodosVC: UIViewController {
    
    private let viewModel = TodosViewModel()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Todos"
        view.backgroundColor = .systemBackground
        
        setupTableView()
        setupSearch()
        fetchData()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupSearch() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Todos by title"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func fetchData() {
        Task {
            await viewModel.fetchData()
            tableView.reloadData()
        }
    }
    
    private func loadNextPage() {
        viewModel.loadNextPage()
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension TodosVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.displayedTodos.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let todo = viewModel.displayedTodos[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let userName = viewModel.getUserName(for: todo.userId)
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = """
        \(todo.title)
        👤 \(userName)
        """
        return cell
    }
}

// MARK: - UITableViewDelegate
extension TodosVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todo = viewModel.displayedTodos[indexPath.row]
        
        Task {
            do {
                let user = try await viewModel.getUser(by: todo.userId)
                let detailVC = TodosDetailVC(todo: todo, user: user)
                self.navigationController?.pushViewController(detailVC, animated: true)
            } catch {
                print("❌ Error fetching user:", error)
            }
        }
    }
    
    // Pagination
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollHeight = scrollView.frame.size.height
        
        if position > (contentHeight - scrollHeight - 100) {
            loadNextPage()
        }
    }
}

// MARK: - UISearchResultsUpdating
extension TodosVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.filter(by: searchController.searchBar.text)
        tableView.reloadData()
    }
}
