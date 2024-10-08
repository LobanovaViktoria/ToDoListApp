//
//  ListInteractor.swift
//  ToDoListApp
//
//  Created by Viktoria Lobanova on 02.09.2024.
//

import UIKit

// MARK: - protocol ListInteractorProtocol

protocol ListInteractorProtocol: AnyObject {
    func getList()
    func syncingAPIAndCorData(list: [TodoAPIModel]?)
    func updateCompleted(idTodo: Int, newValue: Bool)
}

// MARK: - class ListInteractor

final class ListInteractor {
    
    // MARK: - Properties
    
    weak var presenter: ListPresenterProtocol?
    private let service = NetworkLayer()
    private let todosStore = TodosStore()
    private let userDefaultsString = "dataIsSynchronized"
    
    var onError: ((NetworkLayerError) -> Void)?
    
    // MARK: - Init()
    
    init() {
        todosStore.delegate = self
    }
    
    // MARK: - private methods
    
    private func getListFromAPI() {
        service.getList() { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let list):
                    self?.syncingAPIAndCorData(list: list)
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.onError?(error)
                    }
                }
            }
        }
    }
    
    private func getListFromCoreData() {
        self.presenter?.uploadedFromCoreData(list: todosStore.todos)
    }
}

// MARK: - Extension ListInteractorProtocol

extension ListInteractor: ListInteractorProtocol {
    func getList() {
        if UserDefaults.standard.value(
            forKey: userDefaultsString
        ) == nil {
            getListFromAPI()
        }
        
        UserDefaults.standard.set(true, forKey: userDefaultsString)
        getListFromCoreData()
    }
    
    func updateCompleted(idTodo: Int, newValue: Bool) {
        try? todosStore.updateCompleted(idTodo: idTodo, newValue: newValue)
    }
    
    func syncingAPIAndCorData(list: [TodoAPIModel]?) {
        if let list = list {
            try? todosStore.addTodosFromApi(list)
        }
    }
}

// MARK: - extension TodosStoreDelegate

extension ListInteractor: TodosStoreDelegate {
    
    func store(_ store: TodosStore, didUpdate update: TodosUpdate) {
        presenter?.store(list: store.todos)
    }
}
