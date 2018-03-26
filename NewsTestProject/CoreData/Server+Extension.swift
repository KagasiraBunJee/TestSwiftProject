//
//  Server+Extension.swift
//  NewsTestProject
//
//  Created by Sergei on 3/24/18.
//  Copyright © 2018 Sergei. All rights reserved.
//

import Foundation
import CoreData
import ObjectMapper

extension Server: StaticMappable {
    
    public static func objectForMapping(map: Map) -> BaseMappable? {
        
        guard map.JSON["error"] == nil else {
            return nil
        }
        
        guard let requestHostname = map.JSON["hostname"] as? String else {
            return nil
        }
        
        var requestPort = 25000
        if map.JSON["port"] is Int {
            requestPort = map.JSON["port"] as! Int
        } else if map.JSON["port"] is String {
            requestPort = Int(map.JSON["port"] as! String)!
        } else {
            return nil
        }
        
        let predicate = NSPredicate(format: "hostname == %@ AND port == %i", requestHostname, requestPort)
        if let item:Server = Fetcher(context: map.context as! NSManagedObjectContext).fetch(predicate, entityName: "Server") {
            return item
        }
        return Server(context: map.context as! NSManagedObjectContext)
    }
    
    public func mapping(map: Map) {
        
        hostname <- map["hostname"]
        status <- map["status"]
        port <- map["port"]
        queryPort <- map["queryPort"]
        name <- map["name"]
        mapName <- map["map"]
        iprotocol <- map["protocol"]
        players <- (map["players.list"], Player.createTransform(context: map.context as! NSManagedObjectContext))
        maxPlayers <- map["players.max"]
        version <- map["version"]
    }
    
    func currentPlayers() -> [Player] {
        return Array(self.players!) as! [Player]
    }
    
    class func getServers() -> [Server]{
        
        let ctx = CoreDataStackImp.shared.context
        let request = NSFetchRequest<Server>(entityName: "Server")
        
        do {
            let servers = try ctx.fetch(request)
            return servers
        } catch let error {
            debugPrint(error)
            return []
        }
    }
}
