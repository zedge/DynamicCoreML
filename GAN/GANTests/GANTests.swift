//
//  GANTests.swift
//  GANTests
//
//  Created by Jørgen Henrichsen on 21/06/2017.
//  Copyright © 2017 Zedge. All rights reserved.
//

import XCTest
@testable import GAN

class GANTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPreformanceGenerate() {
        let generator = Generator()
        let data = generator.generateRandomData()!
        self.measure {
            for _ in 0...1000 {
                let _ = generator.generate(input: data)
            }
        }
    }
    
}
