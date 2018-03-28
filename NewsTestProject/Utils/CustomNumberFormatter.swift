//
//  CustomNumberFormatter.swift
//  NewsTestProject
//
//  Created by Sergii on 3/28/18.
//  Copyright © 2018 Sergei. All rights reserved.
//

import Foundation

class CustomNumberFormatter {
    
    static let decimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = true
        formatter.decimalSeparator = ","
        return formatter
    }()
}
