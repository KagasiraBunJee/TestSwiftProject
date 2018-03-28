//
//  Weapon+Extension.swift
//  NewsTestProject
//
//  Created by Sergii on 3/28/18.
//  Copyright © 2018 Sergei. All rights reserved.
//

import Foundation
import CoreData
import ObjectMapper

extension Weapon: StaticMappable {
    
    public static func objectForMapping(map: Map) -> BaseMappable? {
        
        let playerName = map.JSON["playerName"] as! String
        
        var weapon:Weapon!
        
        let requestId = (map.JSON["detail"] as! NSDictionary)["id"] as! String
        let predicate = NSPredicate(format: "id == %@", requestId)
        if let item:Weapon = Fetcher(context: map.context as! NSManagedObjectContext).fetch(predicate, entityName: "Weapon") {
            weapon = item
        } else {
            weapon = Weapon(context: map.context! as! NSManagedObjectContext)
        }
        
        let statsPredicate = NSPredicate(format: "name == %@", playerName)
        if let stats:PlayerStats = Fetcher(context: map.context as! NSManagedObjectContext).fetch(statsPredicate, entityName: "PlayerStats") {
            weapon.addToPlayerStats(stats)
        } else {
            return nil
        }
        
        return weapon
    }
    
    public func mapping(map: Map) {
        name <- map["name"]
        id <- map["detail.id"]
        img <- map["detail.image"]
    }
}
