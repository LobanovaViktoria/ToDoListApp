//
//  DetailModuleBulder.swift
//  ToDoListApp
//
//  Created by Viktoria Lobanova on 04.09.2024.
//

import Foundation

final class DetailModuleBuilder {
    
    static func build(with event: Event, todo: TodoModel?) -> DetailViewController {
        let interactor = DetailInteractor()
        let router = DetailRouter()
        let presenter = DetailPresenter(
            router: router,
            interactor: interactor
        )
        let viewController = DetailViewController(event, todo: todo)
        viewController.presenter = presenter
        presenter.view = viewController
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
