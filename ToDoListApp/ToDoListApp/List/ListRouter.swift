//
//  ListRouter.swift
//  ToDoListApp
//
//  Created by Viktoria Lobanova on 02.09.2024.
//

import Foundation
 
protocol ListRouterProtocol {
    func openDetail()
}

class ListRouter: ListRouterProtocol {
    weak var viewController: ListViewController?
    func openDetail() {
        let vc = DetailModuleBulder.build()
        viewController?.present(vc, animated: true, completion: nil)
    }
}
