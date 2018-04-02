//
//  ServerPlayer.swift
//  NewsTestProjectTests
//
//  Created by Sergii on 4/2/18.
//  Copyright © 2018 Sergei. All rights reserved.
//

@testable import NewsTestProject

import XCTest
import Moya

class ServerPlayer: XCTestCase {
    
    var playerService:PlayerServiceImp?
    
    override func setUp() {
        super.setUp()
        
        playerService = PlayerServiceImp(api: MoyaProvider<PlayerInfoApi>(stubClosure: MoyaProvider.immediatelyStub))
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
