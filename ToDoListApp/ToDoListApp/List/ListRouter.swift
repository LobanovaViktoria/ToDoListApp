//
//  ListRouter.swift
//  ToDoListApp
//
//  Created by Viktoria Lobanova on 02.09.2024.
//

import Foundation
 
protocol ListRouterProtocol {
    func openDetailAdd(event: Event)
    func openDetailEdit(event: Event, todo: TodoModel)
}

final class ListRouter: ListRouterProtocol {
    
    weak var viewController: ListViewController?
    
    func openDetailAdd(event: Event) {
        let vc = DetailModuleBuilder.build(with: .add, todo: nil)
        viewController?.present(vc, animated: true, completion: nil)
    }
    
    func openDetailEdit(event: Event, todo: TodoModel) {
        let vc = DetailModuleBuilder.build(with: .edit, todo: todo)
        viewController?.present(vc, animated: true, completion: nil)
    }
}
