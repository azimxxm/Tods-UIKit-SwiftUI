//
//  CacheManager.swift
//  Tods
//
//  Created by Azimjon Abdurasulov on 20/08/25.
//


import Foundation

// CacheManager.swift
final class CacheManager {
    static let shared = CacheManager()
    private init() {}
    
    private let cacheDirectory: URL = {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    }()
    
    func save<T: Codable>(_ data: T, for key: String) {
        let url = cacheDirectory.appendingPathComponent("\(key).json")
        do {
            let encoded = try JSONEncoder().encode(data)
            try encoded.write(to: url)
        } catch {
            print("❌ Cache save error:", error)
        }
    }
    
    func load<T: Codable>(for key: String, as type: T.Type) -> T? {
        let url = cacheDirectory.appendingPathComponent("\(key).json")
        guard FileManager.default.fileExists(atPath: url.path) else { return nil }
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(type, from: data)
        } catch {
            print("❌ Cache load error:", error)
            return nil
        }
    }
}

