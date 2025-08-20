//
//  UsersViewModel.swift
//  Tods
//
//  Created by Azimjon Abdurasulov on 20/08/25.
//

//
//  UsersViewModel.swift
//  Tods
//
//  Created by Azimjon Abdurasulov on 20/08/25.
//

import Foundation

@MainActor
final class UsersViewModel {
    
    private var allUsers: [User] = []
    private(set) var filteredUsers: [User] = []
    
    private let usersCacheKey = "users_cache"
    
    // MARK: - Fetch
    func fetchUsers() async {
        if Reachability.isConnectedToNetwork() {
            do {
                let fetchedUsers: [User] = try await NetworkManager.shared.getUsers()
                self.allUsers = fetchedUsers
                self.filteredUsers = fetchedUsers
                
                // Cache save
                CacheManager.shared.save(fetchedUsers, for: usersCacheKey)
            } catch {
                print("❌ API error:", error)
                loadFromCache()
            }
        } else {
            loadFromCache()
        }
    }
    
    private func loadFromCache() {
        let cached = CacheManager.shared.load(for: usersCacheKey, as: [User].self) ?? []
        self.allUsers = cached
        self.filteredUsers = cached
    }
    

    
    // MARK: - Access
    func user(at index: Int) -> User? {
        guard index < filteredUsers.count else { return nil }
        return filteredUsers[index]
    }
    
    var count: Int {
        return filteredUsers.count
    }
    
    func filter(by query: String?) {
        guard let query, !query.isEmpty else {
            filteredUsers = allUsers
            return
        }

        filteredUsers = allUsers.filter { user in
            return user.name.localizedCaseInsensitiveContains(query) ||
                   user.username.localizedCaseInsensitiveContains(query) ||
                   user.email.localizedCaseInsensitiveContains(query) ||
                   user.phone.localizedCaseInsensitiveContains(query) ||
                   user.website.localizedCaseInsensitiveContains(query)
        }
    }


}
