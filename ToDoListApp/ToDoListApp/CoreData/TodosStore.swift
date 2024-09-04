//
//  TodosStore.swift
//  ToDoListApp
//
//  Created by Viktoria Lobanova on 04.09.2024.
//

import Foundation
import CoreData

struct TodosUpdate {
    struct Move: Hashable {
        let oldIndex: Int
        let newIndex: Int
    }
    let insertedIndexes: IndexSet
    let deletedIndexes: IndexSet
    let updatedIndexes: IndexSet
    let movedIndexes: Set<Move>
}

protocol TodosStoreDelegate: AnyObject {
    func store(
        _ store: TodosStore,
        didUpdate update: TodosUpdate
    )
}

class TodosStore: NSObject {
    weak var delegate: TodosStoreDelegate?
    
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TodoCoreData>!
    private var insertedIndexes: IndexSet?
    private var deletedIndexes: IndexSet?
    private var updatedIndexes: IndexSet?
    private var movedIndexes: Set<TodosUpdate.Move>?
    
    convenience override init() {
        let context = DatabaseManager.shared.context
        self.init(context: context)
        do {
            try fetchedResultsController.performFetch()
        } catch {
            assertionFailure("TodoStore fetch failed")
        }
    }
    
    var todos: [TodoModel] {
        guard let objects = self.fetchedResultsController.fetchedObjects,
                let todos = try? objects.map({ try self.todo(from: $0)})
        else { return [] }
        return todos
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
        
        let fetchRequest = TodoCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TodoCoreData.id, ascending: true)
        ]
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self
        self.fetchedResultsController = controller
    }
    
    func addNewTodo(_ todo: TodoModel) throws {
        let todoCoreData = TodoCoreData(context: context)
        updateExistingTodo(todoCoreData, with: todo)
        try context.save()
    }
    
    func addTodosFromApi(_ todos: [TodoAPIModel]) throws {
        for todo in todos {
            let todoCoreData = TodoCoreData(context: context)
            syncingData(todoCoreData, with: todo)
        }
        try context.save()
    }
    
    func deleteTodo(_ todoToDelete: TodoModel) throws {
        let todo = fetchedResultsController.fetchedObjects?.first {
            $0.id == todoToDelete.id
        }
        if let todo = todo {
            context.delete(todo)
            try context.save()
        }
    }
    
    func updateExistingTodo(_ todoCoreData: TodoCoreData, with todo: TodoModel) {
        todoCoreData.id = Int32(todo.id)
        todoCoreData.userId = Int32(todo.id)
        todoCoreData.completed = todo.completed
        todoCoreData.date = todo.date
        todoCoreData.descriptionTodo = todo.descriptionTodo
        todoCoreData.todo = todo.todo
    }
    
    func syncingData(_ todoCoreData: TodoCoreData, with todoAPI: TodoAPIModel) {
        todoCoreData.id = Int32(todoAPI.id)
        todoCoreData.userId = Int32(todoAPI.id)
        todoCoreData.completed = todoAPI.completed
        todoCoreData.date = Date()
        todoCoreData.descriptionTodo = ""
        todoCoreData.todo = todoAPI.todo
    }
    
    
    func fetchTodo() throws -> [TodoModel] {
        let fetchRequest = TodoCoreData.fetchRequest()
        let todosFromCoreData = try context.fetch(fetchRequest)
        return try todosFromCoreData.map { try self.todo(from: $0) }
    }
    
    func todo(from data: TodoCoreData) throws -> TodoModel {
       
        let id = data.id
        let userId = data.userId
        let completed = data.completed
        
        guard let todo = data.todo else {
            throw DatabaseError.someError
        }
        guard let descriptionTodo = data.descriptionTodo else {
            throw DatabaseError.someError
        }
        guard let date = data.date else {
            throw DatabaseError.someError
        }
        
        return TodoModel(
            id: Int(id),
            todo: todo,
            completed: completed,
            userId: Int(userId),
            date: date,
            descriptionTodo: descriptionTodo
        )
    }
}

extension TodosStore: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            insertedIndexes = IndexSet()
            deletedIndexes = IndexSet()
            updatedIndexes = IndexSet()
            movedIndexes = Set<TodosUpdate.Move>()
        }
    
    func controllerDidChangeContent(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            delegate?.store(
                self,
                didUpdate: TodosUpdate(
                    insertedIndexes: insertedIndexes ?? [],
                    deletedIndexes: deletedIndexes ?? [],
                    updatedIndexes: updatedIndexes ?? [],
                    movedIndexes: movedIndexes ?? []
                )
            )
            insertedIndexes = nil
            deletedIndexes = nil
            updatedIndexes = nil
            movedIndexes = nil
        }
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
        case .insert:
            guard let indexPath = newIndexPath else {
                assertionFailure("insert indexPath - nil")
                return
            }
            insertedIndexes?.insert(indexPath.item)
        case .delete:
            guard let indexPath = indexPath else {
                assertionFailure("delete indexPath - nil")
                return
            }
            deletedIndexes?.insert(indexPath.item)
        case .update:
            guard let indexPath = indexPath else {
                assertionFailure("update indexPath - nil")
                return
            }
            updatedIndexes?.insert(indexPath.item)
        case .move:
            guard let oldIndexPath = indexPath, let newIndexPath = newIndexPath else {
                assertionFailure("move indexPath - nil")
                return
            }
            movedIndexes?.insert(.init(oldIndex: oldIndexPath.item, newIndex: newIndexPath.item))
        @unknown default:
            assertionFailure("unknown case")
        }
    }
}


