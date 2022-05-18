//
//  CoreDataManager.swift
//  TODOList
//
//  Created by 안상희 on 2022/05/18.
//

import CoreData
import Foundation

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() { }
    
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    var list = [TodoEntity]()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TodoModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func create(title: String, content: String, status: String) {
        // 메모리에 저장
        let todoEntity = TodoEntity(context: mainContext)
        todoEntity.title = title
        todoEntity.content = content
        todoEntity.status = status
        todoEntity.insertDate = Date()
        
        // 데이터를 실제로 저장
        saveContext()
        
        list.insert(todoEntity, at: 0)
    }
    
    // Read
    func fetch() {
        list.removeAll()
        
        let request: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest() // fetchReuest

        let sortByInsertDateDesc = NSSortDescriptor(key: "insertDate", ascending: false)
        request.sortDescriptors = [sortByInsertDateDesc]
        
        do {
            let result = try mainContext.fetch(request)
            list.append(contentsOf: result)
        } catch {
            print(error)
        }
    }
    
    
    // Update
    func update(todo: TodoEntity, content: String, title: String, status: String) {
        todo.content = content
        todo.title = title
        todo.status = status
        saveContext()
    }
    
    // Delete
    func delete(todo: TodoEntity) {
        mainContext.delete(todo)
        saveContext()
    }
    
    func delete(at indexPath: IndexPath) {
        let target = list[indexPath.row]
        delete(todo: target)
        list.remove(at: indexPath.row)
    }
}
