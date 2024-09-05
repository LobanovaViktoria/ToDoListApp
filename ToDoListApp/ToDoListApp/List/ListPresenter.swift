//
//  ListPresenter.swift
//  ToDoListApp
//
//  Created by Viktoria Lobanova on 02.09.2024.
//

import Foundation

// MARK: - protocol ListPresenterProtocol

protocol ListPresenterProtocol: AnyObject {
    
    var allTodosCount: Int { get }
    var openTodosCount: Int { get }
    var closedTodosCount: Int { get }
    var todos: [TodoModel] { get }
    
    func viewDidLoaded()
    func uploadedFromCoreData(list: [TodoModel])
    func didTapAddNewTodo(event: Event, todo: TodoModel?)
    func updateCompleted(idTodo: Int, newValue: Bool)
    func update(filter: Filter)
    func store(list: [TodoModel])
}

// MARK: - class ListPresenter

class ListPresenter {
    
    // MARK: - Properties
    
    weak var view: ListViewProtocol?
    var router: ListRouterProtocol
    var interactor: ListInteractorProtocol
    var allTodos: [TodoModel] = []
    var selectedFilter: Filter = .all
    
    // MARK: - Init()
    
    init(
        router: ListRouterProtocol,
        interactor: ListInteractorProtocol)
    {
        self.router = router
        self.interactor = interactor
    }
}

// MARK: - extension ListPresenterProtocol

extension ListPresenter: ListPresenterProtocol {
    var todos: [TodoModel] {
        switch selectedFilter {
        case .all:
            allTodos
        case .open:
            allTodos.filter{ $0.completed == false }
        case .closed:
            allTodos.filter{ $0.completed == true }
        }
    }

    var allTodosCount: Int {
        allTodos.count
    }
    
    var openTodosCount: Int {
        allTodos.filter{ $0.completed == false }.count
    }
    
    var closedTodosCount: Int {
        allTodos.filter{ $0.completed == true }.count
    }
    
    func viewDidLoaded() {
        interactor.getList()
    }
    
    func store(list: [TodoModel]) {
        allTodos = list
        view?.updateList()
        view?.updateCounters()
    }
    
    func uploadedFromCoreData(list: [TodoModel]) {
        allTodos = list
        view?.updateList()
        view?.updateCounters()
    }
    
    func update(filter: Filter) {
        selectedFilter = filter
        view?.updateList()
    }
    
    func didTapAddNewTodo(event: Event, todo: TodoModel?) {
         switch event {
         case .add:
             router.openDetailAdd(event: event)
         case .edit:
             if let todo {
                 router.openDetailEdit(event: event, todo: todo)
             }
         }
    }
    
    func updateCompleted(idTodo: Int, newValue: Bool) {
        interactor.updateCompleted(idTodo: idTodo, newValue: newValue)
    }
}
