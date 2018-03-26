//
//  MoyaProvider+Extension.swift
//  NewsTestProject
//
//  Created by Sergei on 3/24/18.
//  Copyright © 2018 Sergei. All rights reserved.
//

import Foundation
import Moya
import PromiseKit

extension MoyaProvider {
    func request(_ target: Target, progress: ProgressBlock? = .none) -> Promise<Moya.Response> {
        let pending = Promise<Moya.Response>.pending()
        request(target, callbackQueue: .main, progress: progress) { result in
            switch result {
            case .success(let moyaResponse):
                do {
                    let response = try moyaResponse.filterSuccessfulStatusCodes()
                    pending.resolver.fulfill(response)
                } catch {
                    pending.resolver.reject(error)
                }
            case .failure(let error):
                pending.resolver.reject(error)
            }
        }
        return pending.promise
    }
}
