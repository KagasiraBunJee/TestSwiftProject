//
//  ServerService.swift
//  NewsTestProject
//
//  Created by Sergei on 3/24/18.
//  Copyright © 2018 Sergei. All rights reserved.
//

import Foundation
import Moya
import PromiseKit
import ObjectMapper

protocol ServerService: class {
    func addServer(ip:String, port:String, game:GameInfo) -> Promise<Server>
    func refreshServers(endpoints:[String], game:GameInfo) -> Promise<[Server]>
}

final class ServerServiceImp: ServerService {
    
    private var api: MoyaProvider<ServerApi>
    
    init(api: MoyaProvider<ServerApi>) {
        self.api = api
    }
    
    func addServer(ip: String, port: String, game:GameInfo) -> Promise<Server> {
        let pending = Promise<Server>.pending()
        api.request(.addServer(ip: ip, port: port, game: game)).done { (response) in
            
            let jsonString = try response.mapString()
            let mainCtx = CoreDataStackImp.shared.context
            let privateCtx = CoreDataStackImp.shared.privateContext
            
            privateCtx.perform({
                if let object = Mapper<Server>(context: privateCtx).map(JSONString: jsonString) {
                    
                    try! privateCtx.save()
                    mainCtx.performAndWait {
                        try! mainCtx.save()
                        pending.resolver.fulfill(object)
                    }
                } else {
                    pending.resolver.reject(NSError.serverNotFound())
                }
            })
            
        }.catch { (error) in
            pending.resolver.reject(error)
        }
        return pending.promise
    }
    
    func refreshServers(endpoints:[String], game:GameInfo) -> Promise<[Server]> {
        let pending = Promise<[Server]>.pending()
        api.request(.updateServers(endpoints: endpoints, game: game)).done { (response) in
            
            let jsonObject = try response.mapJSON() as! [String:Any]
            let mainCtx = CoreDataStackImp.shared.context
            let privateCtx = CoreDataStackImp.shared.privateContext
            
            privateCtx.perform({
                
                var objects: [Server] = []
                for endpoint in endpoints {
                    if let object = Mapper<Server>(context: privateCtx).map(JSONObject: jsonObject[endpoint]) {
                        objects.append(object)
                    }
                }
                
                try! privateCtx.save()
                mainCtx.performAndWait {
                    try! mainCtx.save()
                    pending.resolver.fulfill(objects)
                }

            })
            
        }.catch { (error) in
                pending.resolver.reject(error)
        }
        return pending.promise
    }
}


