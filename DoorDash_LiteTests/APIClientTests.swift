//
//  APIClientTests.swift
//  DoorDash_LiteTests
//
//  Created by chanikya on 6/4/18.
//  Copyright © 2018 chanikya. All rights reserved.
//

import XCTest
@testable import DoorDash_Lite

class APIClientTests: XCTestCase {
    
    var manager: APIClientManager?
    var lat:Double?
    var lon:Double?
    
    override func setUp() {
        super.setUp()
        
        manager = APIClientManager.sharedInstance
        lat = 51.50007773
        lon = -0.1246402
    }
    
    override func tearDown() {
        lat = nil
        lon = nil
        manager = nil
        super.tearDown()
    }
    
    func test_get_restaurants() {
        
        let expect = XCTestExpectation(description: "callback")
        
        manager?.getRestaurants(lat: lat!, lng: lon!) { (result: [Restaurant]?, error:Error?) in
            expect.fulfill()
        }
        wait(for: [expect], timeout: 3.0)
    }
    
}
