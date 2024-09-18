//
//  DetailPresenter.swift
//  ToDoListApp
//
//  Created by Viktoria Lobanova on 04.09.2024.
//

// MARK: - protocol DetailPresenterProtocol

protocol DetailPresenterProtocol: AnyObject {
    func saveNewTodo(todo: TodoModel?)
    func deleteTodo(todo: TodoModel)
    func updateTodo(_ newTodo: TodoModel, _ editableTodo: TodoModel)
    func closeDetail()
}

// MARK: - class DetailPresenter

final class DetailPresenter {
    
    // MARK: - Properties
    
    weak var view: DetailViewProtocol?
    var router: DetailRouterProtocol
    var interactor: DetailInteractorProtocol
    
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
        interactor.deleteTodo(todo: todo)
        router.closeDetail()
    }
    
    func saveNewTodo(todo: TodoModel?) {
        guard let todo else { return router.closeDetail() }
        interactor.saveNewTodo(todo: todo)
        router.closeDetail()
    }
    
    func updateTodo(_ newTodo: TodoModel, _ editableTodo: TodoModel) {
        interactor.updateTodo(newTodo, editableTodo)
        router.closeDetail()
    }
    
    func closeDetail() {
        router.closeDetail()
    }
}
