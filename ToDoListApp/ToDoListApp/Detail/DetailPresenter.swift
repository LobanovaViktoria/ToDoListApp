//
//  DetailPresenter.swift
//  ToDoListApp
//
//  Created by Viktoria Lobanova on 04.09.2024.
//

protocol DetailPresenterProtocol: AnyObject {
    func viewDidLoaded()
}

class DetailPresenter {
    weak var view: DetailViewProtocol?
    var router: DetailRouterProtocol
    var interactor: DetailInteractorProtocol
    
    init(
        router: DetailRouterProtocol,
        interactor: DetailInteractorProtocol)
    {
        self.router = router
        self.interactor = interactor
    }
}

extension DetailPresenter: DetailPresenterProtocol {
    func viewDidLoaded() {

    }
}

