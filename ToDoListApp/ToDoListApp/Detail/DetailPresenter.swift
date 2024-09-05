//
//  DetailPresenter.swift
//  ToDoListApp
//
//  Created by Viktoria Lobanova on 04.09.2024.
//

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

// MARK: - protocol DetailPresenterProtocol

protocol DetailPresenterProtocol: AnyObject {
    func saveNewTodo(todo: TodoModel?)
    func deleteTodo(todo: TodoModel)
    func updateTodo(_ newTodo: TodoModel, _ editableTodo: TodoModel)
    func closeDetail()
}

// MARK: - class DetailPresenter

class DetailPresenter {
    
    // MARK: - Properties
    
    weak var view: DetailViewProtocol?
    var router: DetailRouterProtocol
    var interactor: DetailInteractorProtocol
    
    private let todosStore = TodosStore()
    
    // MARK: - Init()
    
    init(
        router: DetailRouterProtocol,
        interactor: DetailInteractorProtocol)
    {
        self.router = router
        self.interactor = interactor
    }
}

// MARK: - extension DetailPresenterProtocol

extension DetailPresenter: DetailPresenterProtocol {
    func deleteTodo(todo: TodoModel) {
        try? todosStore.deleteTodo(todo)
        router.closeDetail()
    }
    
    func saveNewTodo(todo: TodoModel?) {
        guard let todo else { return router.closeDetail() }
        try? todosStore.addNewTodo(todo)
        router.closeDetail()
    }
    
    func updateTodo(_ newTodo: TodoModel, _ editableTodo: TodoModel) {
        try? todosStore.updateTodo(newTodo.todo, editableTodo)
        router.closeDetail()
    }
    
    func closeDetail() {
        router.closeDetail()
    }
}
