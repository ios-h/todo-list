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
    
    var persistentContainer: NSPersistentContainer? // container를 저장할 속성
    
    var mainContext: NSManagedObjectContext {
        guard let context = persistentContainer?.viewContext else {
            fatalError()
        }
        return context
    }
    
    
    func setUp(modelName: String) {
        persistentContainer = NSPersistentContainer(name: "TodoModel")
        persistentContainer?.loadPersistentStores(completionHandler: { desc, error in
            if let error = error {
                fatalError(error.localizedDescription)
            }
        })
    }
    
    
    func saveContext() {
        mainContext.perform {
            if self.mainContext.hasChanges {
                do {
                    try self.mainContext.save()
                    print("Save Context!")
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
    }
}
