//
//  DataBaseManager.swift
//  ToDoListApp
//
//  Created by Viktoria Lobanova on 04.09.2024.
//

import Foundation
import CoreData

enum DatabaseError: Error {
    case someError
}

final class DatabaseManager {
    
    private let modelName = "Todos"
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    init() {
        _ = persistentContainer
    }
    
    static let shared = DatabaseManager()
    
    // MARK: - Core Data stack
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
}

