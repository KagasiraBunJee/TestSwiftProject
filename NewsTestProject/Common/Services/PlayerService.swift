//
//  PlayerService.swift
//  NewsTestProject
//
//  Created by Sergei on 3/25/18.
//  Copyright © 2018 Sergei. All rights reserved.
//

import Foundation
import Moya
import PromiseKit
import ObjectMapper

protocol PlayerService: class {
    func playerStats(playerName:String) -> Promise<PlayerStats>
}

final class PlayerServiceImp: PlayerService {
    
    private var api: MoyaProvider<PlayerInfoApi>
    private var dataStack:CoreDataStack!
    
    static let shared = PlayerServiceImp(api: MoyaProvider<PlayerInfoApi>(), coreDataStack: CoreDataStackImp.default)
    
    init(api: MoyaProvider<PlayerInfoApi>, coreDataStack: CoreDataStack) {
        self.api = api
        self.dataStack = coreDataStack
    }
    
    func playerStats(playerName: String) -> Promise<PlayerStats> {
        let pending = Promise<PlayerStats>.pending()
        api.request(.playerInfo(playerName: playerName, game: .bf4)).done { (response) in
            
            var object:PlayerStats?
            let jsonString = try response.mapString()
            
            self.dataStack.perform(with: { (privateContext) in
                object = Mapper<PlayerStats>(context: privateContext).map(JSONString: jsonString)
            }, onMainContext: nil, completion: {
                if let stat = object {
                    pending.resolver.fulfill(stat)
                } else {
                    pending.resolver.reject(NSError.nothingFound())
                }
            })
            
        }.catch { (error) in
            pending.resolver.reject(error)
        }
        return pending.promise
    }
}
