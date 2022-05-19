//
//  CoreDataManager+Todo.swift
//  TODOList
//
//  Created by 안상희 on 2022/05/19.
//

import CoreData
import Foundation

extension CoreDataManager {
    // Create
    func create(title: String, content: String, status: MemoStatus, completion: (() -> ())? = nil) {
        mainContext.perform {
            let todoEntity = TodoEntity(context: self.mainContext)
            todoEntity.title = title
            todoEntity.content = content
            todoEntity.status = status.description
            todoEntity.createdDate = Date()
            
            self.saveContext()
            completion?()
        }
    }
    
    // Read
    func fetch() -> [TodoEntity] {
        var todoList = [TodoEntity]()
        
        mainContext.performAndWait {
            let request: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
            
            let sortByDate = NSSortDescriptor(key: #keyPath(TodoEntity.createdDate), ascending: true)
            request.sortDescriptors = [sortByDate]
            
            do {
                todoList = try mainContext.fetch(request)
            } catch {
                print(error)
            }
        }
        return todoList
    }
    
    // Update
    func update(entity: TodoEntity, title: String, content: String, status: MemoStatus, completion: (() -> ())? = nil) {
        mainContext.perform {
            entity.title = title
            entity.content = content
            entity.status = status.description
            
            self.saveContext()
            completion?()
        }
    }
    
    // Delete
    func delete(entity: TodoEntity) {
        mainContext.perform {
            self.mainContext.delete(entity)
            self.saveContext()
        }
    }
}
