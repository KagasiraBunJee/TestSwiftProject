//
//  Utils.swift
//  NewsTestProject
//
//  Created by Sergii on 3/28/18.
//  Copyright © 2018 Sergei. All rights reserved.
//

import UIKit

class Utils {

    class func timestampToHoursAndMinutes(timestamp: Int) -> String {
        
        let minuteInSeconds:Float = 1 * 60
        let hourInSeconds:Float = minuteInSeconds * 60
        
        var hours:Float = 0
        var minutes:Float = 0
        var hoursString = ""
        var minutesString = "1m"
        
        if Float(timestamp) > hourInSeconds {
            hours = floor(Float(timestamp)/hourInSeconds)
            hoursString = String(format: "%.0fh ", hours)
        }
        
        if Float(timestamp) > minuteInSeconds {
            minutes = (Float(timestamp) - ( hours * hourInSeconds ))/minuteInSeconds
            minutesString = String(format: "%.0fm", minutes)
        }
        
        return hoursString+minutesString
    }
    
}
