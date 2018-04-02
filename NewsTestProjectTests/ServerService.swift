//
//  ServerService.swift
//  NewsTestProjectTests
//
//  Created by Sergii on 4/2/18.
//  Copyright © 2018 Sergei. All rights reserved.
//

@testable import NewsTestProject

import XCTest
import Moya

class ServerService: XCTestCase {
    
    var serverService: ServerServiceImp?
    
    override func setUp() {
        super.setUp()
        
        serverService = ServerServiceImp(api: MoyaProvider<ServerApi>(stubClosure: MoyaProvider.immediatelyStub))
    }
    
    override func tearDown() {
        serverService = nil
        super.tearDown()
    }
    
    func testAddServer() {
        let serverExpectation = expectation(description: "Add server")

        let testApi = "94.250.199.113"
        let testPort = "25200"
        
        serverService?.addServer(ip: testApi, port: testPort, game: .bf4).done { server -> Void in
            XCTAssertNotNil(server)
            XCTAssertTrue(server.status)
            XCTAssertNotNil(server.hostname)
            XCTAssertEqual(testApi, server.hostname!)
            serverExpectation.fulfill()
        }.catch { error -> Void in
            XCTFail(error.localizedDescription)
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testServersListUpdate() {
        let serverExpectation = expectation(description: "Update Server List")
        
        let endpoints = ["176.57.170.12:25200","94.250.199.113:25200"]
        
        serverService?.refreshServers(endpoints: endpoints, game: .bf4).done { servers -> Void in
            XCTAssertNotNil(servers)
            XCTAssert(servers.count > 0)
            serverExpectation.fulfill()
        }.catch { error -> Void in
            XCTFail(error.localizedDescription)
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
}
