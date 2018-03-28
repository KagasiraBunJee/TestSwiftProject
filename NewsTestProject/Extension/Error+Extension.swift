//
//  Error+Extension.swift
//  NewsTestProject
//
//  Created by Sergei on 3/25/18.
//  Copyright © 2018 Sergei. All rights reserved.
//

import Foundation

extension NSError {
    
    static func serverNotFound() -> Error {
        let err = NSError(domain: "mappingError", code: 0, userInfo: [
            NSLocalizedFailureReasonErrorKey: "Server not found"
        ])
        return err
    }
    
    static func nothingFound() -> Error {
        let err = NSError(domain: "mappingError", code: 0, userInfo: [
            NSLocalizedFailureReasonErrorKey: "Nothing found"
        ])
        return err
    }
}
