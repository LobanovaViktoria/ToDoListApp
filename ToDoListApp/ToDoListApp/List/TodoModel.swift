//
//  ListModel.swift
//  ToDoListApp
//
//  Created by Viktoria Lobanova on 03.09.2024.
//

import Foundation

// MARK: - Welcome

struct Welcome: Codable {
    let todos: [TodoAPIModel]
    let total, skip, limit: Int
}

// MARK: - TodoAPIModel

struct TodoAPIModel: Codable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}

// MARK: - TodoModel

struct TodoModel: Codable, Hashable {
    var id: Int
    var todo: String
    var completed: Bool
    var userId: Int
    var date: Date
    var descriptionTodo: String
}
