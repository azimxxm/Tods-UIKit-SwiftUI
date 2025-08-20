//
//  TodosViewModel.swift
//  Tods
//
//  Created by Azimjon Abdurasulov on 20/08/25.
//


//
//  TodosViewModel.swift
//  Tods
//
//  Created by Azimjon Abdurasulov on 20/08/25.
//

//
//  TodosViewModel.swift
//  Tods
//

import Foundation

@MainActor
final class TodosViewModel: ObservableObject {
    private(set) var todos: [Todo] = []
    private(set) var users: [User] = []
    private(set) var displayedTodos: [Todo] = []
    
    private var currentPage = 1
    private let limit = 20
    
    private let todosCacheKey = "todos_cache"
    private let usersCacheKey = "users_cache"
    
    func fetchData() async {
        if Reachability.isConnectedToNetwork() {
            do {
                async let allTodos: [Todo] = NetworkManager.shared.getTodos(page: 1, limit: 200)
                async let allUsers: [User] = NetworkManager.shared.getUsers()
                
                let (todosResult, usersResult) = try await (allTodos, allUsers)
                
                self.todos = todosResult
                self.users = usersResult
                
                // Cache save
                CacheManager.shared.save(todosResult, for: todosCacheKey)
                CacheManager.shared.save(usersResult, for: usersCacheKey)
                
                // Reset pagination
                self.currentPage = 1
                self.displayedTodos = []
                loadNextPage()
            } catch {
                print("❌ API Error:", error)
                loadFromCache()
            }
        } else {
            loadFromCache()
        }
    }
    
    private func loadFromCache() {
        self.todos = CacheManager.shared.load(for: todosCacheKey, as: [Todo].self) ?? []
        self.users = CacheManager.shared.load(for: usersCacheKey, as: [User].self) ?? []
        
        self.currentPage = 1
        self.displayedTodos = []
        loadNextPage()
    }
    
    func loadNextPage() {
        let startIndex = (currentPage - 1) * limit
        let endIndex = min(startIndex + limit, todos.count)
        
        guard startIndex < todos.count else { return }
        
        let nextTodos = Array(todos[startIndex..<endIndex])
        displayedTodos.append(contentsOf: nextTodos)
        currentPage += 1
    }
    
    func getUserName(for userId: Int) -> String {
        return users.first(where: { $0.id == userId })?.name ?? "Unknown User"
    }
    
    func getUser(by userId: Int) async throws -> User {
        if let cachedUser = users.first(where: { $0.id == userId }) {
            return cachedUser
        }
        return try await NetworkManager.shared.getUser(id: userId)
    }
    

    func filter(by query: String?) {
        guard let query = query, !query.isEmpty else {
            // agar bo‘sh bo‘lsa → hammasini qaytar
            displayedTodos = Array(todos.prefix(currentPage * limit))
            return
        }
        
        displayedTodos = todos.filter { $0.title.localizedCaseInsensitiveContains(query) }
    }
}
