//
//  DetailInteractor.swift
//  ToDoListApp
//
//  Created by Viktoria Lobanova on 04.09.2024.
//

import UIKit

protocol DetailInteractorProtocol: AnyObject {
  
}

class DetailInteractor: DetailInteractorProtocol {
    
    weak var presenter: DetailPresenterProtocol?
}

