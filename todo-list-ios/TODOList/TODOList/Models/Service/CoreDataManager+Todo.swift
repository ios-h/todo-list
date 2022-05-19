//
//  CoreDataManager+Todo.swift
//  TODOList
//
//  Created by 안상희 on 2022/05/19.
//

import CoreData
import Foundation

extension CoreDataManager {
    // TodoEntity 생성 메소드
    func create(title: String, content: String, status: MemoStatus, completion: (() -> ())? = nil) {
        mainContext.perform {
            let todoEntity = TodoEntity(context: self.mainContext)
            todoEntity.title = title
            todoEntity.content = content
            todoEntity.status = status.description
            todoEntity.insertDate = Date()
            
            self.saveContext()
            completion?()
        }
    }
}
