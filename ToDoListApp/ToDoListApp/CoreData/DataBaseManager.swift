//
//  DataBaseManager.swift
//  ToDoListApp
//
//  Created by Viktoria Lobanova on 04.09.2024.
//

import Foundation
import CoreData

// MARK: - DatabaseError

enum DatabaseError: Error {
    case someError
}

// MARK: - class DatabaseManager

final class DatabaseManager {
    
    // MARK: - Properties
    
    private let modelName = "Todos"
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    // MARK: - Init()
    
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
