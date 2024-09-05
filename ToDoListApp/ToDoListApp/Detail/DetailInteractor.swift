//
//  DetailInteractor.swift
//  ToDoListApp
//
//  Created by Viktoria Lobanova on 04.09.2024.
//

import UIKit

// MARK: - enum Event

enum Event {
    case add
    case edit
    
    var titleVC: String {
        switch self {
        case .add:
            return "addTodoTitle".localized
        case .edit:
            return "editTodoTitle".localized
        }
    }
}

// MARK: - protocol DetailInteractorProtocol

protocol DetailInteractorProtocol: AnyObject {
    func deleteTodo(todo: TodoModel)
    func saveNewTodo(todo: TodoModel)
    func updateTodo(_ newTodo: TodoModel, _ editableTodo: TodoModel)
}

class DetailInteractor {
    
    // MARK: - Properties
    
    weak var presenter: DetailPresenterProtocol?
    private let todosStore = TodosStore()
}

// MARK: - DetailInteractorProtocol

extension DetailInteractor: DetailInteractorProtocol {
    func saveNewTodo(todo: TodoModel) {
        try? todosStore.addNewTodo(todo)
    }
    
    func deleteTodo(todo: TodoModel) {
        try? todosStore.deleteTodo(todo)
    }
    
    func updateTodo(_ newTodo: TodoModel, _ editableTodo: TodoModel) {
        try? todosStore.updateTodo(newTodo.todo, editableTodo)
    }
}
