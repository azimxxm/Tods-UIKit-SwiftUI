//
//  TodosByUserID.swift
//  Tods
//
//  Created by Azimjon Abdurasulov on 20/08/25.
//


import UIKit

final class TodosByUserID: UIViewController {
    
    private let viewModel: TodosByUserIDViewModel
    private let tableView = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)
    
    init(userId: Int) {
        self.viewModel = TodosByUserIDViewModel(userId: userId)
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Todos"
        view.backgroundColor = .systemBackground
        setupTableView()
        setupSearch()
        fetchTodos()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TodoCell.self, forCellReuseIdentifier: TodoCell.identifier)
    }
    
    
    private func setupSearch() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Todos by title"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func fetchTodos() {
        Task {
            await viewModel.fetchTodos()
            tableView.reloadData()
        }
    }
}

extension TodosByUserID: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoCell.identifier, for: indexPath) as? TodoCell else {
            return UITableViewCell()
        }
        if let todo = viewModel.todo(at: indexPath.row) {
            cell.configure(with: todo)
        }
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height * 2 {
            guard !viewModel.isLoading,viewModel.hasMoreData else { return }
            fetchTodos()
        }
    }
}

// MARK: - UISearchResultsUpdating
extension TodosByUserID: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.filter(by: searchController.searchBar.text)
        tableView.reloadData()
    }
}
