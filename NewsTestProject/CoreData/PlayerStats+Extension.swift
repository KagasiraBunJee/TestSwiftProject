//
//  PlayerStats+Extension.swift
//  NewsTestProject
//
//  Created by Sergei on 3/27/18.
//  Copyright © 2018 Sergei. All rights reserved.
//

import Foundation
import CoreData
import ObjectMapper

extension PlayerStats: StaticMappable {
    
    public static func objectForMapping(map: Map) -> BaseMappable? {
        
        let requestName = (map.JSON["player"] as! NSDictionary)["name"] as! String
        
        let predicate = NSPredicate(format: "name == %@", requestName)
        if let item:PlayerStats = Fetcher(context: map.context as! NSManagedObjectContext).fetch(predicate, entityName: "PlayerStats") {
            return item
        }
        let stat = PlayerStats(context: map.context as! NSManagedObjectContext)
        
        if let owner:Player = Fetcher(context: map.context as! NSManagedObjectContext).fetch(predicate, entityName: "Player") {
            stat.player = owner
        }
        
        return stat
    }
    
    public func mapping(map: Map) {
        
        //player general stats
        name <- map["player.name"]
        blStatsLink <- map["player.blPlayer"]
        blUserLink <- map["player.blUser"]
        dateCheck <- (map["player.dateCheck"], CustomTransform.fromStringToDate())
        dateCreate <- (map["player.dateCreate"], CustomTransform.fromStringToDate())
        dateStreak <- (map["player.dateStreak"], CustomTransform.fromStringToDate())
        dateUpdate <- (map["player.dateUpdate"], CustomTransform.fromStringToDate())
        lastDay <- (map["player.lastDay"], CustomTransform.fromStringToDate(formatter: CustomDateFormatter.simpleFormatter))
        timePlayed <- map["player.timePlayed"]
        nextRankScore <- map["player.rank.next.needed"]
        
        //player combat stats
        currentRankScore <- map["stats.scores.rankScore"]
        deaths <- map["stats.deaths"]
        headshots <- map["stats.headshots"]
        kills <- map["stats.kills"]
        longestHeadshot <- map["stats.longestHeadshot"]
        numLosses <- map["stats.numLosses"]
        numRounds <- map["stats.numRounds"]
        numWins <- map["stats.numWins"]
        shotsFired <- map["stats.shotsFired"]
        shotsHit <- map["stats.shotsHit"]
        
        rank <- map["player.rank"]
    }
}
