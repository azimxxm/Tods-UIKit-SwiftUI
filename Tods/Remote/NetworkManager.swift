//
//  NetworkManager.swift
//  Tods
//
//  Created by Azimjon Abdurasulov on 20/08/25.
//

import Foundation

// MARK: - NetworkManager
final class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://jsonplaceholder.typicode.com"
    private let session = URLSession.shared
    
    private init() {}
    
    // MARK: - Generic Request
    private func fetchData<T: Decodable>(from url: URL) async throws -> T {
        let (data, _) = try await session.data(from: url)
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    // MARK: - Todos
    func getTodos(page: Int, limit: Int) async throws -> [Todo] {
        guard let url = URL(string: "\(baseURL)/todos") else {
            throw URLError(.badURL)
        }
        
        let todos: [Todo] = try await fetchData(from: url)
        
        // Local pagination
        let startIndex = (page - 1) * limit
        let endIndex = min(startIndex + limit, todos.count)
        
        if startIndex < todos.count {
            return Array(todos[startIndex..<endIndex])
        } else {
            return []
        }
    }
    
    func getTodo(id: Int) async throws -> Todo {
        guard let url = URL(string: "\(baseURL)/todos/\(id)") else {
            throw URLError(.badURL)
        }
        return try await fetchData(from: url)
    }
    
    // MARK: - Users
    func getUsers() async throws -> [User] {
        guard let url = URL(string: "\(baseURL)/users") else {
            throw URLError(.badURL)
        }
        return try await fetchData(from: url)
    }
    
    func getUser(id: Int) async throws -> User {
        guard let url = URL(string: "\(baseURL)/users/\(id)") else {
            throw URLError(.badURL)
        }
        return try await fetchData(from: url)
    }
    
    
    // MARK: - Todos for specific user
    func getTodosForUser(userId: Int, page: Int, limit: Int) async throws -> [Todo] {
        guard let url = URL(string: "\(baseURL)/users/\(userId)/todos") else {
            throw URLError(.badURL)
        }
        
        let todos: [Todo] = try await fetchData(from: url)
        
        // Local pagination
        let startIndex = (page - 1) * limit
        let endIndex = min(startIndex + limit, todos.count)
        
        if startIndex < todos.count {
            return Array(todos[startIndex..<endIndex])
        } else {
            return []
        }
    }

}
