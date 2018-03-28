//
//  TransformOf+Extension.swift
//  NewsTestProject
//
//  Created by Sergei on 3/27/18.
//  Copyright © 2018 Sergei. All rights reserved.
//

import Foundation
import ObjectMapper
import CoreData

struct MappableTransform<T: BaseMappable> {
    
    private var context:NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func relationshipSetTransform() -> TransformOf<NSSet, [[String: Any]]> {
        let trnsf = relationshipSetTransform(withAdditionalKeyValues: nil)
        return trnsf
    }
    
    func relationshipSetTransform(withAdditionalKeyValues: [String:Any]? = nil) -> TransformOf<NSSet, [[String: Any]]> {
        return TransformOf<NSSet, [[String: Any]]>(
            fromJSON: { (value: [[String: Any]]?) -> NSSet? in
                var jsonObject = value
                if let adds = withAdditionalKeyValues {
                    jsonObject = jsonObject?.map({ (values) -> [String: Any] in
                        return values.merging(adds) { (_, new) in new }
                    })
                }
                return NSSet(array: Mapper<T>(context: self.context).mapArray(JSONObject: jsonObject!)!)
        },
            toJSON: { (value: NSSet?) -> [[String: Any]]? in
                if let value = value, let allObjects = value.allObjects as? [T] {
                    return allObjects.toJSON()
                }
                return nil
        })
    }
    
    func relationshipSingleObjectTransform() -> TransformOf<T, [String: Any]> {
        let trnsf = relationshipSingleObjectTransform(withAdditionalKeyValues: nil)
        return trnsf
    }
    
    func relationshipSingleObjectTransform(withAdditionalKeyValues: [String:Any]? = nil) -> TransformOf<T, [String: Any]> {
        return TransformOf<T, [String: Any]>(
            fromJSON: { (value: [String: Any]?) -> T? in
                var jsonObject = value
                if let adds = withAdditionalKeyValues {
                    jsonObject = value?.merging(adds) { (_, new) in new }
                }
                return Mapper<T>(context: self.context).map(JSONObject: jsonObject)
        },
            toJSON: { (value: T?) -> [String: Any]? in
                return value?.toJSON()
        })
    }
}

class CustomTransform {
    
    static func fromStringToInt() -> TransformOf<Int32, String> {
        return TransformOf<Int32, String>(fromJSON: { (value: String?) -> Int32? in
            return Int32(value!)
        }, toJSON: { (value: Int32?) -> String? in
            if let value = value {
                return String(value)
            }
            return nil
        })
    }
    
    static func fromStringToDate() -> TransformOf<Date, String> {
        return TransformOf<Date, String>(fromJSON: { (value: String?) -> Date? in
            
            guard let value = value else {
                return nil
            }
            if let interval = Double(value) {
                return Date(timeIntervalSince1970: interval)
            }
            return nil
        }, toJSON: { (value: Date?) -> String? in
            if let value = value {
                return String(value.timeIntervalSince1970)
            }
            return nil
        })
    }
    
    static func fromStringToDate(formatter: DateFormatter) -> TransformOf<Date, String> {
        return TransformOf<Date, String>(fromJSON: { (value: String?) -> Date? in
            
            guard let value = value else {
                return nil
            }
            return formatter.date(from: value)
        }, toJSON: { (value: Date?) -> String? in
            if let value = value {
                return String(value.timeIntervalSince1970)
            }
            return nil
        })
    }
}
