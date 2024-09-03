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
    func didLoad(list: [Todo]?)
}

// MARK: - class ListPresenter

class ListPresenter {
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
    
    func viewDidLoaded() {
        interactor.getList()
    }
    
    func didLoad(list: [Todo]?) {
        if  let list = list {
            view?.showList(list: list)
        }
    }
}
