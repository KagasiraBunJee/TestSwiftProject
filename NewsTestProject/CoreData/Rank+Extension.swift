//
//  Rank+Extension.swift
//  NewsTestProject
//
//  Created by Sergei on 3/27/18.
//  Copyright © 2018 Sergei. All rights reserved.
//

import Foundation
import CoreData
import ObjectMapper

extension Rank: StaticMappable {
    
    public static func objectForMapping(map: Map) -> BaseMappable? {
        
        let requestId = map.JSON["nr"] as! Int
        
        let predicate = NSPredicate(format: "id == %i", requestId)
        if let item:Rank = Fetcher(context: map.context as! NSManagedObjectContext).fetch(predicate, entityName: "Rank") {
            return item
        }
        return Rank(context: map.context as! NSManagedObjectContext)
    }
    
    public func mapping(map: Map) {
        id <- map["nr"]
        img <- map["img"]
        name <- map["name"]
        neededRankScore <- map["needed"]
        rankProgress <- map["relProg"]
        
        next <- map["next"]
    }
}
