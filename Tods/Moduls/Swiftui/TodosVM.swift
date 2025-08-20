//
//  TodosVM.swift
//  Tods
//
//  Created by Azimjon Abdurasulov on 20/08/25.
//
import SwiftUI

@MainActor
class TodosVM: ObservableObject {
    @Published var todos: [Todo] = []
    @Published var displayedTodos: [Todo] = []
    @Published var page: Int = 1
    @Published var limit: Int = 1000
    @Published var searchText: String = ""
    private let todosCacheKey = "todos_cache"
    
    
    func fetchTodos() async {
        if Reachability.isConnectedToNetwork() {
            Task {
                do {
                    let todo = try await NetworkManager.shared.getTodos(page: page, limit: limit)
                    if !todo.isEmpty {
                        self.todos.append(contentsOf: todo)
                        self.displayedTodos.append(contentsOf: todo)
                        self.page += 1
                        CacheManager.shared.save(self.todos, for: todosCacheKey)
                    }
                } catch let error {
                    print("❌ API Error:", error)
                    loadFromCache()
                }
            }
        } else {
            loadFromCache()
        }

    }
    
    private func loadFromCache() {
        let todos =  CacheManager.shared.load(for: todosCacheKey, as: [Todo].self) ?? []
        self.todos = todos
        self.displayedTodos = todos

    }
    
    
    func isLastItem(for item: Todo)-> Bool {
        guard !todos.isEmpty else { return false }
        guard let last = todos.last else { return false }
        return last.id == item.id
    }
    
    
    func loadMore(with item: Todo) {
        guard isLastItem(for: item) else { return }
        Task { await fetchTodos() }
    }
    
    
    func filter(by query: String?) {
        guard let query = query, !query.isEmpty else {
            // agar bo‘sh bo‘lsa → hammasini qaytar
            displayedTodos = todos
            return
        }
        
        displayedTodos = todos.filter { $0.title.localizedCaseInsensitiveContains(query) }
    }
}
