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

enum Team: Int {
    case spectator
    case first = 1
    case second = 2
    
    var named:String {
        get {
            switch self {
            case .first:
                return NSLocalizedString("team_name_first", comment: "name of team 1")
            case .second:
                return NSLocalizedString("team_name_second", comment: "name of team 2")
            default:
                return NSLocalizedString("team_queue", comment: "name of group of people who is in queue")
            }
        }
    }
}

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
        tag <- map["tag"]
        timePlayed <- map["timePlayed"]
        viewable <- map["viewable"]
        
        score <- (map["score"], Player.transformFromStringToInt())
        kills <- (map["kills"], Player.transformFromStringToInt())
        deaths <- (map["deaths"], Player.transformFromStringToInt())
        rank <- map["rank"]
        ping <- (map["ping"], Player.transformFromStringToInt())
        teamId <- (map["teamId"], Player.transformFromStringToInt())
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

extension Player {
    class func transformFromStringToInt() -> TransformOf<Int32, String> {
        return TransformOf<Int32, String>(fromJSON: { (value: String?) -> Int32? in
            return Int32(value!)
        }, toJSON: { (value: Int32?) -> String? in
            if let value = value {
                return String(value)
            }
            return nil
        })
    }
}
