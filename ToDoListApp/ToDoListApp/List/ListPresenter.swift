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
    func uploadedFromCoreData()
    func syncingAPIAndCorData(list: [TodoAPIModel]?)
    func didTapAddNewTodo(event: Event, todo: TodoModel?)
    func updateCompleted(idTodo: Int, newValue: Bool)
}

// MARK: - class ListPresenter

class ListPresenter {
    
    // MARK: - Properties
    
    private let userDefaultsString = "dataIsSynchronized"
    private let todosStore = TodosStore()
    
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
        todosStore.delegate = self
    }
}

// MARK: - extension ListPresenterProtocol

extension ListPresenter: ListPresenterProtocol {
   
    var allTodos: Int {
        todosStore.todos.count
    }
    
    var openTodos: Int {
        todosStore.todos.filter(
            {
                $0.completed == false
            }
        ).count
    }
    
    var closedTodos: Int {
        todosStore.todos.filter(
            {
                $0.completed == true
            }
        ).count
    }
    
    func viewDidLoaded() {
        if UserDefaults.standard.value(forKey: userDefaultsString) == nil {
            interactor.getListFromAPI()
        }
        UserDefaults.standard.set(true, forKey: userDefaultsString)
        interactor.getListFromCoreData()
    }
    
    func syncingAPIAndCorData(list: [TodoAPIModel]?) {
        if let list = list {
            try? todosStore.addTodosFromApi(list)
        }
    }
    
    func uploadedFromCoreData() {
        view?.showList(list: todosStore.todos)
    }
    
    func didTapAddNewTodo(event: Event, todo: TodoModel?) {
        router.openDetail(event: event, todo: todo)
    }
    
    func updateCompleted(idTodo: Int, newValue: Bool) {
        try? todosStore.updateCompleted(idTodo: idTodo, newValue: newValue)
    }
    
}

// MARK: - TodosStoreDelegate

extension ListPresenter: TodosStoreDelegate {
    
    func store(_ store: TodosStore, didUpdate update: TodosUpdate) {
        view?.showList(list: store.todos)
        view?.updateCounters()
    }
}
