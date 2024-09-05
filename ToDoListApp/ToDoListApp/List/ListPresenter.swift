//
//  ListPresenter.swift
//  ToDoListApp
//
//  Created by Viktoria Lobanova on 02.09.2024.
//

import Foundation

// MARK: - protocol ListPresenterProtocol

protocol ListPresenterProtocol: AnyObject {
    
    var allTodos: Int { get }
    var openTodos: Int { get }
    var closedTodos: Int { get }
    
    func viewDidLoaded()
    func uploadedFromCoreData(list: [TodoModel])
    func didTapAddNewTodo(event: Event, todo: TodoModel?)
    func updateCompleted(idTodo: Int, newValue: Bool)
    func store(list: [TodoModel]) 
}

// MARK: - class ListPresenter

class ListPresenter {
    
    // MARK: - Properties
    
    weak var view: ListViewProtocol?
    var router: ListRouterProtocol
    var interactor: ListInteractorProtocol
    
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
   
    var allTodos: Int {
        interactor.allTodos
    }
    
    var openTodos: Int {
        interactor.openTodos
    }
    
    var closedTodos: Int {
        interactor.closedTodos
    }
    
    func viewDidLoaded() {
        interactor.getList()
    }
    
    func store(list: [TodoModel]) {
        view?.showList(list: list)
        view?.updateCounters()
    }
    
    func uploadedFromCoreData(list: [TodoModel]) {
        view?.showList(list: list)
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
