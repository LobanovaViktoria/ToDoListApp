//
//  ListInteractor.swift
//  ToDoListApp
//
//  Created by Viktoria Lobanova on 02.09.2024.
//

import UIKit

protocol ListInteractorProtocol: AnyObject {
    func getListFromAPI()
    func getListFromCoreData()
}

class ListInteractor {
    
    // MARK: - Properties
    
    weak var presenter: ListPresenterProtocol?
    private let service = NetworkLayer()
  
    var onError: ((NetworkLayerError) -> Void)?
}

// MARK: - Extension ListInteractorProtocol

extension ListInteractor: ListInteractorProtocol {
    func getListFromAPI() {
        service.getList() { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let list):
                    self?.presenter?.syncingAPIAndCorData(list: list)
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.onError?(error)
                    }
                }
            }
        }
    }
    
    func getListFromCoreData() {
        self.presenter?.uploadedFromCoreData()
    }
}
