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
    private var dataStack:CoreDataStack!
    
    static let shared = ServerServiceImp(api: MoyaProvider<ServerApi>(), coreDataStack: CoreDataStackImp.default)
    
    init(api: MoyaProvider<ServerApi>, coreDataStack: CoreDataStack) {
        self.api = api
        self.dataStack = coreDataStack
    }
    
    func addServer(ip: String, port: String, game:GameInfo) -> Promise<Server> {
        let pending = Promise<Server>.pending()
        api.request(.addServer(ip: ip, port: port, game: game)).done { (response) in
            
            self.dataStack.performSingleSave(with: { (context) -> Server? in
                do {
                    let jsonString = try response.mapString()
                    return Mapper<Server>(context: context).map(JSONString: jsonString)
                } catch {
                    return nil
                }
            }, completion: { (object:Server?) in
                if let server = object {
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
            
            self.dataStack.performMultipleSaving(with: { (context) -> [Server]? in
                do {
                    let jsonObject = try response.mapJSON() as! [String:Any]
                    
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
                    return objects
                } catch {
                    return nil
                }
            }, completion: { (servers:[Server]?) in
                pending.resolver.fulfill(servers ?? [])
            })
            
        }.catch { (error) in
            pending.resolver.reject(error)
        }
        return pending.promise
    }
}


