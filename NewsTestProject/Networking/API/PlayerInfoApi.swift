//
//  PlayerInfoApi.swift
//  NewsTestProject
//
//  Created by Sergei on 3/24/18.
//  Copyright © 2018 Sergei. All rights reserved.
//

import Foundation
import Moya

enum PlayerInfoApi {
    case playerInfo(playerName:String, game:GameInfo)
}

extension PlayerInfoApi: TargetType {
    
    var baseURL: URL {
        switch self {
        case .playerInfo(_ , let game):
            let gameApiType = game.rawValue.uppercased()
            let urlPath = "\(Bundle.main.object(forInfoDictionaryKey: "PLAYER_INFO_\(gameApiType)_API")!)"
            return URL(string: urlPath)!
        }
    }
    
    var path: String {
        switch self {
        case .playerInfo(_, _):
            return "playerInfo"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .playerInfo(_, _):
            return .get
        }
    }
    
    var sampleData: Data {
        switch self {
        case .playerInfo(_, _):
            return NSDataAsset(name: "PlayerStats")!.data
        }
    }
    
    var task: Task {
        switch self {
        case .playerInfo(let playerName, _):
            return .requestParameters(parameters: ["plat":"pc", "name":playerName], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return [:]
    }
}
