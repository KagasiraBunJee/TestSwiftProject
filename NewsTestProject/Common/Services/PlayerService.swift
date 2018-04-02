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
    
    static let shared = PlayerServiceImp(api: MoyaProvider<PlayerInfoApi>())
    
    init(api: MoyaProvider<PlayerInfoApi>) {
        self.api = api
    }
    
    func playerStats(playerName: String) -> Promise<PlayerStats> {
        let pending = Promise<PlayerStats>.pending()
        api.request(.playerInfo(playerName: playerName, game: .bf4)).done { (response) in
            
            do {
                let responseObject = try response.mapString()
                
                var object:PlayerStats?
                
                CoreDataStackImp.default.perform(with: { (context) in
                    object = Mapper<PlayerStats>(context: context).map(JSONString: responseObject)
                }, onMainContext: nil, completion: {
                    if let stat = object {
                        pending.resolver.fulfill(stat)
                    } else {
                        pending.resolver.reject(NSError.nothingFound())
                    }
                })
                
            } catch let error {
                pending.resolver.reject(error)
            }
            
        }.catch { (error) in
            pending.resolver.reject(error)
        }
        return pending.promise
    }
}
