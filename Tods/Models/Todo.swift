//
//  Todo.swift
//  Tods
//
//  Created by Azimjon Abdurasulov on 20/08/25.
//
import Foundation

struct Todo: Codable, Identifiable {
    let id: Int
    let userId: Int
    let title: String
    let completed: Bool
}
