//
//  Fetcher.swift
//  NewsTestProject
//
//  Created by Sergei on 3/25/18.
//  Copyright © 2018 Sergei. All rights reserved.
//

import UIKit
import CoreData

protocol ObjectFetcher {
    var context: NSManagedObjectContext { get set }
    
    func fetch<T>(withRequest request: NSFetchRequest<T>) -> [T]
    func fetchArray<T>(_ predicate: NSPredicate, entityName: String) -> [T] where T: NSFetchRequestResult
}

class Fetcher: ObjectFetcher {
    
    var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func fetch<T>(_ predicate: NSPredicate, entityName: String) -> T? where T: NSFetchRequestResult {
        let request =  NSFetchRequest<T>(entityName: entityName)
        request.predicate = predicate
        
        return fetch(withRequest: request).first
    }
    
    func fetchArray<T>(_ predicate: NSPredicate, entityName: String) -> [T] where T: NSFetchRequestResult {
        let request =  NSFetchRequest<T>(entityName: entityName)
        request.predicate = predicate
        
        return fetch(withRequest: request)
    }
    
    func fetchAll<T>(entityName: String) -> [T] where T: NSFetchRequestResult {
        let request = NSFetchRequest<T>(entityName: entityName)
        return fetch(withRequest: request)
    }
    
    func fetch<T>(withRequest request: NSFetchRequest<T>) -> [T] {
        return (try? context.fetch(request)) ?? []
    }

}
