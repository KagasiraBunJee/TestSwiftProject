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
    
    static let shared = ServerServiceImp(api: MoyaProvider<ServerApi>())
    
    init(api: MoyaProvider<ServerApi>) {
        self.api = api
    }
    
    func addServer(ip: String, port: String, game:GameInfo) -> Promise<Server> {
        let pending = Promise<Server>.pending()
        api.request(.addServer(ip: ip, port: port, game: game)).done { (response) in
            
            var server:Server?
            let jsonString = try response.mapString()
            
            CoreDataStackImp.default.perform(with: { (privateContext) in
                server = Mapper<Server>(context: privateContext).map(JSONString: jsonString)
            }, onMainContext: nil, completion: {
                if let server = server {
                    pending.resolver.fulfill(server)
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
            
            var servers:[Server] = []
            
            CoreDataStackImp.default.perform(with: { (context) in
                var objects: [Server] = []
                if endpoints.count > 1 {
                    for endpoint in endpoints {
                        if let object = Mapper<Server>(context: context).map(JSONObject: jsonObject[endpoint]) {
                            objects.append(object)
                        }
                    }
                } else {
                    if let object = Mapper<Server>(context: context).map(JSONObject: jsonObject) {
                        objects.append(object)
                    }
                }
                servers = objects
            }, onMainContext: nil, completion: {
                pending.resolver.fulfill(servers)
            })
            
        }.catch { (error) in
                pending.resolver.reject(error)
        }
        return pending.promise
    }
}


