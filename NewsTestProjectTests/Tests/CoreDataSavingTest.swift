//
//  CoreDataSavingTest.swift
//  NewsTestProjectTests
//
//  Created by Sergei on 4/3/18.
//  Copyright © 2018 Sergei. All rights reserved.
//

@testable import NewsTestProject

import XCTest
import Moya

class CoreDataSavingTest: XCTestCase {
    
    var coreDataStack:CoreDataStackImp?
    
    override func setUp() {
        super.setUp()
        
        coreDataStack = CoreDataStackImp(container: CoreDataStackMock.mockPersistantContainer)
    }
    
    override func tearDown() {
        coreDataStack = nil
        super.tearDown()
    }
    
    func testSaving(){
        coreDataStack?.performSingleSave(with: { (context) -> Server? in
            let obj = Server(context: context)
            obj.hostname = "1.1.1.1"
            obj.port = 1111
            return obj
        }, completion: { (object) in
            XCTAssertNotNil(object)
            XCTAssertEqual(object!.hostname!, "1.1.1.1")
        })
    }
}
