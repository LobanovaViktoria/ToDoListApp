//
//  ListViewController.swift
//  ToDoListApp
//
//  Created by Viktoria Lobanova on 02.09.2024.
//

import UIKit

protocol ListViewProtocol: AnyObject {
    func showList()
}

class ListViewController: UIViewController {

    var presenter: ListPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.red
        presenter?.viewDidLoaded()
    }
}

extension ListViewController: ListViewProtocol {
    func showList() {
         
    }
}
