//
//  WeaponStat+Extension.swift
//  NewsTestProject
//
//  Created by Sergii on 3/28/18.
//  Copyright © 2018 Sergei. All rights reserved.
//

import Foundation
import CoreData
import ObjectMapper

extension WeaponStat: StaticMappable {
    
    public static func objectForMapping(map: Map) -> BaseMappable? {
        
        guard let playerName = map.JSON["playerName"] as? String else {
            return nil
        }
        
        //weapon ID
        guard let requestId = (map.JSON["detail"] as! NSDictionary)["id"] as? String else {
            return nil
        }

        var weaponStat: WeaponStat!
        
        let predicate = NSPredicate(format: "weaponId == %@ AND playerName == %@", requestId, playerName)
        if let fetchedItem:WeaponStat = Fetcher(context: map.context as! NSManagedObjectContext).fetch(predicate, entityName: "WeaponStat") {
            weaponStat = fetchedItem
        } else {
            //if doesn't exist create new one
            weaponStat = WeaponStat(context: map.context! as! NSManagedObjectContext)
        }
        
        //fetch user stats to make relationship with weapon stats
        let statsPredicate = NSPredicate(format: "name == %@", playerName)
        if let stats:PlayerStats = Fetcher(context: map.context as! NSManagedObjectContext).fetch(statsPredicate, entityName: "PlayerStats") {
            weaponStat.playerStats = stats
        } else {
            return nil
        }
        
        //connect weapon entity to WeaponStats
        let weaponPredicate = NSPredicate(format: "id == %@", requestId)
        if let weapon:Weapon = Fetcher(context: map.context as! NSManagedObjectContext).fetch(weaponPredicate, entityName: "Weapon") {
            weaponStat.weapon = weapon
        }
        
        return weaponStat
    }
    
    public func mapping(map: Map) {
        playerName <- map["playerName"]
        
        weaponId <- map["detail.id"]
        accuracy <- map["extra.accuracy"]
        kpm <- map["extra.kpm"]
        kills <- map["stat.kills"]
    }
    
    class func getTopKillsStatsByUser(name:String, count: Int) -> [WeaponStat] {
        
        let context = CoreDataStackImp.default.context
        let request = NSFetchRequest<WeaponStat>(entityName: "WeaponStat")
        request.sortDescriptors = [NSSortDescriptor(key: "kills", ascending: false)]
        request.predicate = NSPredicate(format: "playerName == %@", name)
        request.fetchLimit = count
        
        do {
            return try context.fetch(request) as [WeaponStat]
        } catch {
            return []
        }
    }
}
