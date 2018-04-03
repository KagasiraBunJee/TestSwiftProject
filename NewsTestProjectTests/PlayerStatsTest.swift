//
//  PlayerStatsTest.swift
//  NewsTestProjectTests
//
//  Created by Sergei on 4/3/18.
//  Copyright © 2018 Sergei. All rights reserved.
//

@testable import NewsTestProject

import XCTest
import Moya

class PlayerStatsTest: XCTestCase {
    
    var playerService:PlayerServiceImp?
    
    override func setUp() {
        super.setUp()
        
        playerService = PlayerServiceImp(api: MoyaProvider<PlayerInfoApi>(stubClosure: MoyaProvider.immediatelyStub),
                                         coreDataStack: CoreDataStackImp(container: CoreDataStackMock.mockPersistantContainer))
    }
    
    override func tearDown() {
        playerService = nil
        super.tearDown()
    }
    
    func testPlayerInfo() {
        
        let serverExpectation = expectation(description: "Player Info")
        
        playerService?.playerStats(playerName: "").done { player -> Void in
            XCTAssertNotNil(player)
            XCTAssertNotNil(player.name)
            XCTAssertEqual(player.name!, "lHistoric")
            
            //rank
            XCTAssertNotNil(player.rank)
            XCTAssertEqual(player.rank!.id, 33)
            serverExpectation.fulfill()
        }.catch { error -> Void in
            XCTFail(error.localizedDescription)
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
}
