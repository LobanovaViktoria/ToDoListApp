//
//  ListRouter.swift
//  ToDoListApp
//
//  Created by Viktoria Lobanova on 02.09.2024.
//

import Foundation
 
protocol ListRouterProtocol {
    func openDetail(event: Event, todo: TodoModel?)
}

class ListRouter: ListRouterProtocol {
    
    weak var viewController: ListViewController?
    
    func openDetail(event: Event, todo: TodoModel?) {
        let vc = DetailModuleBulder.build(event: event, todo: todo)
        viewController?.present(vc, animated: true, completion: nil)
    }
}
