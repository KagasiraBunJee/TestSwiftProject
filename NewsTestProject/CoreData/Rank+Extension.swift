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
        
        let playerName = map.JSON["playerName"] as! String
        let requestId = map.JSON["nr"] as! Int
        
        var rank:Rank!
        
        let predicate = NSPredicate(format: "id == %i", requestId)
        if let item:Rank = Fetcher(context: map.context as! NSManagedObjectContext).fetch(predicate, entityName: "Rank") {
            rank = item
        } else {
            rank = Rank(context: map.context! as! NSManagedObjectContext)
        }
        
        let statsPredicate = NSPredicate(format: "name == %@", playerName)
        guard let stats:PlayerStats = Fetcher(context: map.context as! NSManagedObjectContext).fetch(statsPredicate, entityName: "PlayerStats") else {
            return nil
        }
        
        rank.addToPlayerStats(stats)
        
        return rank
    }
    
    public func mapping(map: Map) {
        
        let plName = map.JSON["playerName"] as! String
        
        id <- map["nr"]
        img <- map["img"]
        name <- map["name"]
        neededRankScore <- map["needed"]
        needRankScoreRel <- map["relNeeded"]
        
        next <- (map["next"], MappableTransform<Rank>(context: map.context as! NSManagedObjectContext).relationshipSingleObjectTransform(withAdditionalKeyValues: ["playerName" : plName]))
    }
}
