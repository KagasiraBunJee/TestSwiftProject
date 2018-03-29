//
//  CoreDataStack.swift
//  NewsTestProject
//
//  Created by Sergei on 3/24/18.
//  Copyright © 2018 Sergei. All rights reserved.
//

import Foundation
import CoreData

protocol CoreDataStack {
    var persistentContainer: NSPersistentContainer { get }
    var context: NSManagedObjectContext { get }
    var privateContext: NSManagedObjectContext { get }
    
    func perform(onBackgroundContext:((NSManagedObjectContext) -> Void)?, onMainContext:((NSManagedObjectContext) -> Void)?, completion:(() -> Void)?)
    func saveContext()
}

final class CoreDataStackImp: CoreDataStack {
    
    static let shared = CoreDataStackImp()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "NewsTestProject")
        container.loadPersistentStores(completionHandler: { (d, error) in
            if let error = error as NSError? {
                debugPrint("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var context: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    lazy var privateContext: NSManagedObjectContext = {
        let privateCtx = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateCtx.parent = context
        privateCtx.automaticallyMergesChangesFromParent = true
        return privateCtx
    }()
    
    func perform(onBackgroundContext:((NSManagedObjectContext) -> Void)?, onMainContext:((NSManagedObjectContext) -> Void)?, completion:(() -> Void)?) {
        let mainCtx = context
        let privateCtx = privateContext
        
        privateCtx.perform({
            onBackgroundContext?(privateCtx)
            try! privateCtx.save()
            mainCtx.performAndWait {
                onMainContext?(mainCtx)
                try! mainCtx.save()
                completion?()
            }
        })
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                debugPrint("CoreData saveContext: Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
