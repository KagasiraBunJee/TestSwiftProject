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
        
        let playerName = (map.JSON["player"] as! NSDictionary)["name"] as! String
        
        let predicate = NSPredicate(format: "name == %@", playerName)
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
        
        let plName = (map.JSON["player"] as! NSDictionary)["name"] as! String
        
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
        currentScore <- map["player.score"]
        
        //player combat stats
        deaths <- map["stats.deaths"]
        headshots <- map["stats.headshots"]
        kills <- map["stats.kills"]
        longestHeadshot <- map["stats.longestHeadshot"]
        numLosses <- map["stats.numLosses"]
        numRounds <- map["stats.numRounds"]
        numWins <- map["stats.numWins"]
        shotsFired <- map["stats.shotsFired"]
        shotsHit <- map["stats.shotsHit"]
        kdr <- map["stats.extra.kdr"]
        spm <- map["stats.extra.spm"]   
        kpm <- map["stats.extra.kpm"]
        squadScore <- map["stats.scores.squad"]
        
        rank <- (map["player.rank"], MappableTransform<Rank>(context: map.context as! NSManagedObjectContext).relationshipSingleObjectTransform(withAdditionalKeyValues: ["playerName" : plName]))
        rankStat <- (map["player.rank"], MappableTransform<RankStat>(context: map.context as! NSManagedObjectContext).relationshipSingleObjectTransform(withAdditionalKeyValues: ["playerName" : plName]))
        
        weapons <- (map["weapons"], MappableTransform<Weapon>(context: map.context as! NSManagedObjectContext).relationshipSetTransform(withAdditionalKeyValues: ["playerName" : plName]))
        weaponStats <- (map["weapons"], MappableTransform<WeaponStat>(context: map.context as! NSManagedObjectContext).relationshipSetTransform(withAdditionalKeyValues: ["playerName" : plName]))
    }
}
