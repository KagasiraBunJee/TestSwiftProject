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
    
    func perform(with privateContext:((NSManagedObjectContext) -> Void)?, onMainContext:((NSManagedObjectContext) -> Void)?, completion:(() -> Void)?)
    func saveContext()
}

final class CoreDataStackImp: CoreDataStack {
    
    private(set) var persistentContainer:NSPersistentContainer
    
    init(container: NSPersistentContainer) {
        self.persistentContainer = container
        self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    static let `default`: CoreDataStackImp = {
        let container = NSPersistentContainer(name: "NewsTestProject")
        container.loadPersistentStores(completionHandler: { (d, error) in
            if let error = error as NSError? {
                debugPrint("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return CoreDataStackImp(container: container)
    }()
    
    lazy var context: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    func perform(with privateContext:((NSManagedObjectContext) -> Void)?, onMainContext:((NSManagedObjectContext) -> Void)?, completion:(() -> Void)?) {
        
        let mainCtx = context
        persistentContainer.performBackgroundTask { (privateCtx) in
            privateContext?(privateCtx)
            try! privateCtx.save()
            mainCtx.performAndWait {
                try! mainCtx.save()
                completion?()
            }
        }
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
