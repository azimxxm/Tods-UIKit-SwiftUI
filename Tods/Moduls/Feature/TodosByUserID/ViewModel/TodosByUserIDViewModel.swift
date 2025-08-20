//
//  TodosByUserIDViewModel.swift
//  Tods
//
//  Created by Azimjon Abdurasulov on 20/08/25.
//

import Foundation

@MainActor
final class TodosByUserIDViewModel {
    
    private let userId: Int
    private let cacheKey: String
    
    private(set) var allTodos: [Todo] = []
    private(set) var displayedTodos: [Todo] = []  
    
    private var currentPage = 1
    private let limit = 20
    var isLoading = false
    var hasMoreData = true
    
    init(userId: Int) {
        self.userId = userId
        self.cacheKey = "todos_user_\(userId)"
    }
    
    func fetchTodos() async {
        guard !isLoading else { return }
        isLoading = true
        
        defer { isLoading = false }
        
        if Reachability.isConnectedToNetwork() {
            do {
                let newTodos = try await NetworkManager.shared.getTodosForUser(
                    userId: userId,
                    page: currentPage,
                    limit: limit
                )
                
                if !newTodos.isEmpty {
                    allTodos.append(contentsOf: newTodos)
                    displayedTodos = allTodos
                    CacheManager.shared.save(allTodos, for: cacheKey)
                    currentPage += 1
                }
            } catch {
                print("❌ API error:", error)
                loadFromCache()
            }
        } else {
            loadFromCache()
        }
    }
    
    private func loadFromCache() {
        self.allTodos = CacheManager.shared.load(for: cacheKey, as: [Todo].self) ?? []
        self.displayedTodos = allTodos
    }
    
    func todo(at index: Int) -> Todo? {
        guard index < displayedTodos.count else { return nil }
        return displayedTodos[index]
    }
    
    var count: Int {
        return displayedTodos.count
    }
    

    func filter(by query: String?) {
        guard let query = query, !query.isEmpty else {
            displayedTodos = allTodos
            return
        }
        displayedTodos = allTodos.filter { $0.title.localizedCaseInsensitiveContains(query) }
    }
}
