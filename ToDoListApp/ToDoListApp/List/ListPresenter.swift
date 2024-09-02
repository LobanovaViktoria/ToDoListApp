//
//  ListPresenter.swift
//  ToDoListApp
//
//  Created by Viktoria Lobanova on 02.09.2024.
//

import Foundation

protocol ListPresenterProtocol: AnyObject {
    func viewDidLoaded()
}

class ListPresenter {
    weak var view: ListViewProtocol?
    var router: ListRouterProtocol
    var interactor: ListInteractorProtocol
    
    init(
        router: ListRouterProtocol,
        interactor: ListInteractorProtocol)
    {
        self.router = router
        self.interactor = interactor
    }
    
}

extension ListPresenter: ListPresenterProtocol {
    func viewDidLoaded() {
        
    }
}
