//
//  Player+Extension.swift
//  NewsTestProject
//
//  Created by Sergei on 3/25/18.
//  Copyright © 2018 Sergei. All rights reserved.
//

import Foundation
import CoreData
import ObjectMapper

extension Player: StaticMappable {

    public static func objectForMapping(map: Map) -> BaseMappable? {
        
        let requestName = map.JSON["name"] as! String
        
        let predicate = NSPredicate(format: "name == %@", requestName)
        if let item:Player = Fetcher(context: map.context as! NSManagedObjectContext).fetch(predicate, entityName: "Player") {
            return item
        }
        return Player(context: map.context as! NSManagedObjectContext)
    }
    
    public func mapping(map: Map) {
        dateCheck <- map["dateCheck"]
        dateCreate <- map["dateCreate"]
        dateStreak <- map["dateStreak"]
        dateUpdate <- map["dateUpdate"]
        editable <- map["editable"]
        game <- map["game"]
        id <- map["id"]
        name <- map["name"]
        platform <- map["platform"]
        score <- map["score"]
        tag <- map["tag"]
        timePlayed <- map["timePlayed"]
        viewable <- map["viewable"]
        servers <- map["server"]
    }
    
}

extension Player {
    class func createTransform(context: NSManagedObjectContext) -> TransformOf<NSSet, [[String: Any]]> {
        return TransformOf<NSSet, [[String: Any]]>(
            fromJSON: { (value: [[String: Any]]?) -> NSSet? in
                return NSSet(array: Mapper<Player>(context: context).mapArray(JSONObject: value!)!)
        },
            toJSON: { (value: NSSet?) -> [[String: Any]]? in
                if let value = value, let allObjects = value.allObjects as? [Player] {
                    return allObjects.toJSON()
                }
                return nil
        })
    }
}
