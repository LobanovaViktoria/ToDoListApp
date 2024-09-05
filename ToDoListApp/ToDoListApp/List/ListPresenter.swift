//
//  ListPresenter.swift
//  ToDoListApp
//
//  Created by Viktoria Lobanova on 02.09.2024.
//

import Foundation

// MARK: - protocol ListPresenterProtocol

protocol ListPresenterProtocol: AnyObject {
    
    func viewDidLoaded()
    func uploadedFromCoreData()
    func syncingAPIAndCorData(list: [TodoAPIModel]?)
    func didTapAddNewTodo()
}

// MARK: - class ListPresenter

class ListPresenter {
    
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
    
    func didTapAddNewTodo() {
        router.openDetail()
    }
}

extension ListPresenter: TodosStoreDelegate {
    
    func store(_ store: TodosStore, didUpdate update: TodosUpdate) {
        view?.showList(list: store.todos)
    }
}
