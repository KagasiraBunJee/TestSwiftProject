//
//  NSManagedObjectContext+Extension.swift
//  NewsTestProject
//
//  Created by Sergei on 3/25/18.
//  Copyright © 2018 Sergei. All rights reserved.
//

import Foundation
import ObjectMapper
import CoreData

protocol Context: MapContext {
    var customArgs:[String:Any] { get set }
}

extension NSManagedObjectContext: MapContext {}
