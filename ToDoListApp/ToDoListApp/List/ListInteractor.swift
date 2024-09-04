//
//  ListInteractor.swift
//  ToDoListApp
//
//  Created by Viktoria Lobanova on 02.09.2024.
//

import UIKit

protocol ListInteractorProtocol: AnyObject {
    func getList()
    //func getImageForCurrentTemperature() -> UIImage?
}

class ListInteractor: ListInteractorProtocol {
    weak var presenter: ListPresenterProtocol?
    
    func getList(){
        
    }
}
