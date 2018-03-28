//
//  CustomDateFormatter.swift
//  NewsTestProject
//
//  Created by Sergei on 3/27/18.
//  Copyright © 2018 Sergei. All rights reserved.
//

import Foundation

class CustomDateFormatter {
    
    static let simpleFormatter : DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyddMM"
        return dateFormatter
    }()
    
}
