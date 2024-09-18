//
//  DetailRouter.swift
//  ToDoListApp
//
//  Created by Viktoria Lobanova on 04.09.2024.
//


protocol DetailRouterProtocol {
    func closeDetail()
}

final class DetailRouter: DetailRouterProtocol {
    
    weak var viewController: DetailViewController?
    
    func closeDetail() {
        viewController?.dismiss(animated: false)
    }
}
