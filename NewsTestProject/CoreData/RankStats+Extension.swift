//
//  RankStat+Extension.swift
//  NewsTestProject
//
//  Created by Sergii on 3/28/18.
//  Copyright © 2018 Sergei. All rights reserved.
//

import Foundation
import CoreData
import ObjectMapper

extension RankStat: StaticMappable {
    
    public static func objectForMapping(map: Map) -> BaseMappable? {
        
        guard let playerName = map.JSON["playerName"] as? String else {
            return nil
        }
        
        var rankStat:RankStat!
        
        let predicate = NSPredicate(format: "playerName == %@", playerName)
        if let item:RankStat = Fetcher(context: map.context as! NSManagedObjectContext).fetch(predicate, entityName: "RankStat") {
            rankStat = item
        } else {
            rankStat = RankStat(context: map.context! as! NSManagedObjectContext)
        }
        
        let statsPredicate = NSPredicate(format: "name == %@", playerName)
        if let stats:PlayerStats = Fetcher(context: map.context as! NSManagedObjectContext).fetch(statsPredicate, entityName: "PlayerStats") {
            rankStat.playerStat = stats
        } else {
            return nil
        }
        
        guard let rankID:Int = map.JSON["nr"] as? Int else {
            return nil
        }
        
        let rankPredicate = NSPredicate(format: "id == %i", rankID)
        if let rank:Rank = Fetcher(context: map.context as! NSManagedObjectContext).fetch(rankPredicate, entityName: "Rank") {
            rankStat.rank = rank
        }
        
        return rankStat
    }
    
    public func mapping(map: Map) {
        playerName <- map["playerName"]
        rankCurrentRel <- map["next.relCurr"]
        rankProgress <- map["next.relProg"]
        rankCurrent <- map["next.curr"]
    }
}

