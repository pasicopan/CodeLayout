//
//  CodeLayoutTests.swift
//  CodeLayoutTests
//
//  Created by LiShuo on 14/11/22.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

import UIKit
import XCTest
import CodeLayout

class CodeLayoutTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testOperations() {
        var add: BaseOperation = Value(30) + 50
        XCTAssertNotNil(add)
        XCTAssertTrue(add.calculate(Node()).value == 80)
        
        var sub = Value(50) - Value(30)
        XCTAssertTrue(sub.calculate(Node()).value == 20)
        
        var mul = Value(2) * Value(3)
        XCTAssertTrue(mul.calculate(Node()).value == 6)
        
        var div = Value(6) / Value(3)
        XCTAssertTrue(div.calculate(Node()).value == 2)
        
        var min = Min(left: Value(20), right: Value(30) + 40)
        XCTAssertTrue(min.calculate(Node()).value == 20)
        
        var max = Max(left: Value(20), right: Value(30) + 40)
        XCTAssertTrue(max.calculate(Node()).value == 70)
    }
    
    func testNodeConstrain(){
        var node = Node()
        
        node.calculatedLeft = 30
        node.calculatedHCenter = 45
        XCTAssert(node.calculatedWidth! == 30)
        XCTAssert(node.calculatedRight! == 60)
        
        node = Node()
        node.calculatedLeft = 30
        node.calculatedWidth = 20
        XCTAssert(node.calculatedRight! == 50)
        XCTAssert(node.calculatedHCenter! == 40)
        
        node = Node()
        node.calculatedLeft = 30
        node.calculatedRight = 50
        XCTAssert(node.calculatedWidth! == 20)
        XCTAssert(node.calculatedHCenter! == 40)
        
        node = Node()
        node.calculatedRight = 30
        node.calculatedHCenter = 20
        XCTAssert(node.calculatedLeft! == 10)
        XCTAssert(node.calculatedWidth! == 20)
        
        node = Node()
        node.calculatedRight = 30
        node.calculatedWidth = 20
        XCTAssert(node.calculatedLeft! == 10)
        XCTAssert(node.calculatedHCenter! == 20)
        
        node = Node()
        node.calculatedTop = 30
        node.calculatedHeight = 20
        XCTAssert(node.calculatedBottom! == 50)
        XCTAssert(node.calculatedVCenter! == 40)
        
        node = Node()
        node.calculatedTop = 30
        node.calculatedBottom = 50
        XCTAssert(node.calculatedHeight! == 20)
        XCTAssert(node.calculatedVCenter! == 40)
        
        node = Node()
        node.calculatedBottom = 30
        node.calculatedVCenter = 20
        XCTAssert(node.calculatedTop! == 10)
        XCTAssert(node.calculatedHeight! == 20)
        
        node = Node()
        node.calculatedBottom = 30
        node.calculatedHeight = 20
        XCTAssert(node.calculatedTop! == 10)
        XCTAssert(node.calculatedVCenter! == 20)
        
        node = Node(left: Value(0), right: Value(500), top: Value(0), height: Value(500))
        node.calculateWithRound()
        XCTAssert(node.calculatedTop! == 0)
    }
    
    func testNodeOperation() {
        var node = Node(width: Value(200))
        var childNode1 = Node(left: Value(20), width: ParentWidth * 0.3 + 10 - 30)
        var childNode2 = Node(left: PrevLeft + 20, width: NextLeft - MeLeft)
        var childNode3 = Node(left: PrevLeft + 80)
        
        node.addSubNode(childNode1)
        node.addSubNode(childNode2)
        node.addSubNode(childNode3)
        
        var result = node.calculateWithRound(1)
        XCTAssertFalse(result.complete)
        
        result = node.calculateWithRound(3)
        XCTAssertTrue(result.complete)
        
        XCTAssertTrue(childNode1.calculatedWidth != nil)
        XCTAssertTrue(childNode1.calculatedWidth! == 40)
        XCTAssertTrue(childNode2.calculatedLeft! == 40)
        XCTAssertTrue(childNode3.calculatedLeft! == 120)
        XCTAssertTrue(childNode2.calculatedWidth! == 80)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            for i in 0..<10000 {
                var max = Max(left: Value(20), right: Value(30) + Value(40))
                XCTAssertTrue(max.calculate(Node()).value == 70)
            }
        }
    }
    
}
