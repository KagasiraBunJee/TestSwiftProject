//
//  CoreDataMock.swift
//  NewsTestProjectTests
//
//  Created by Sergei on 4/3/18.
//  Copyright © 2018 Sergei. All rights reserved.
//
@testable import NewsTestProject

import UIKit
import CoreData

class CoreDataStackMock {
    
    static let mockPersistantContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "NewsTestProject")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false
        
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            precondition( description.type == NSInMemoryStoreType )
            
            if let error = error {
                fatalError("Create an in-mem coordinator failed \(error)")
            }
        }
        return container
    }()
}
