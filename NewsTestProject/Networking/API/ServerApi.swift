//
//  ServerApi.swift
//  NewsTestProject
//
//  Created by Sergei on 3/24/18.
//  Copyright © 2018 Sergei. All rights reserved.
//

import Foundation
import Moya

enum GameInfo:String {
    case bf4
}

enum ServerApi {
    case addServer(ip: String, port: String, game:GameInfo)
    case updateServers(endpoints:[String], game:GameInfo)
}

extension ServerApi : TargetType {
    
    var baseURL: URL {
        let urlPath = "\(Bundle.main.object(forInfoDictionaryKey: "SERVER_INFO_API")!)"
        return URL(string: urlPath)!
    }
    
    var path: String {
        switch self {
        case .addServer(let ip, let port, let game):
            return String(format: "%@/query/info/%@:%@", game.rawValue, ip, port)
        case .updateServers(let endpoints, let game):
            let stringArray = endpoints.joined(separator: ",")
            return String(format: "%@/query/info/%@", game.rawValue, stringArray)
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .addServer(_, _, _):
            return .get
        case .updateServers(_, _):
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .addServer(_, _, _):
            return .requestPlain
        case .updateServers(_, _):
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return [:]
    }
}
