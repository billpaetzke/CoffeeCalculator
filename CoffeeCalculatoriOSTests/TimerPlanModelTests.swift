//
//  CoffeeCalculatoriOSTests.swift
//  CoffeeCalculatoriOSTests
//
//  Created by Bill Paetzke on 4/1/20.
//  Copyright © 2020 Bill Paetzke. All rights reserved.
//

import XCTest
@testable import CoffeeCalculatoriOS
//@testable import CoffeeCalculator

class TimerPlanModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTimerPlanInitial() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let planTitle = "Sample"
        let plan = TimerPlan(title: planTitle, stages: [])
        XCTAssertEqual(plan.title, planTitle)
        XCTAssertEqual(plan.stages.count, 0)
        XCTAssertEqual(plan.duration, 0)
        XCTAssertEqual(plan.pourMass, 0)
        XCTAssertEqual(plan.pours, 0)
        XCTAssertNotNil(plan.instructions)
        XCTAssertNil(plan.instructions.get(at: 0))
        XCTAssertFalse(plan.instructions.isEnd(at: 0))
    }
    
    func testTimerPlanInitialCopy() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let planTitle = "Sample"
        let plan = TimerPlan(title: planTitle, stages: [TimerPlanStage(pourRate: 5, duration: 10)])
        let copied = TimerPlan(plan)
        XCTAssertNotEqual(plan, copied)
        XCTAssertNotEqual(plan.id, copied.id)
        XCTAssertEqual(plan.title, copied.title)
        XCTAssertEqual(plan.stages, copied.stages)
    }
    
    func testTimerPlanInitialNewRef() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let planTitle = "Sample"
        let plan = TimerPlan(title: planTitle, stages: [TimerPlanStage(pourRate: 5, duration: 10)])
        let newRef = plan
        XCTAssertEqual(plan, newRef)
        XCTAssertEqual(plan.id, newRef.id)
        XCTAssertEqual(plan.title, newRef.title)
        XCTAssertEqual(plan.stages, newRef.stages)
    }
    
    func testTimerPlanOneStage() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let planTitle = "Sample"
        var plan = TimerPlan(title: planTitle, stages: [])
        let originalInstructions = plan.instructions
        plan.stages.append(TimerPlanStage(pourRate: 5, duration: 10))
        XCTAssertNotEqual(originalInstructions, plan.instructions)
        XCTAssertEqual(plan.stages.count, 1)
        XCTAssertEqual(plan.duration, 10)
        XCTAssertEqual(plan.pourMass, 50)
        XCTAssertEqual(plan.pours, 1)
        XCTAssertNotNil(plan.instructions)
        XCTAssertNil(plan.instructions.get(at: -3))
        XCTAssertNil(plan.instructions.get(at: -2))
        XCTAssertNil(plan.instructions.get(at: -1))
        XCTAssertNotNil(plan.instructions.get(at: 0))
        XCTAssertEqual(plan.instructions.get(at: 0)?.fromTime, 0)
        XCTAssertEqual(plan.instructions.get(at: 0)?.toTime, 10)
        XCTAssertEqual(plan.instructions.get(at: 0)?.fromMass, 0)
        XCTAssertEqual(plan.instructions.get(at: 0)?.toMass, 50)
        XCTAssertEqual(plan.instructions.get(at: 0), plan.instructions.get(at: 1))
        XCTAssertEqual(plan.instructions.get(at: 0), plan.instructions.get(at: 2))
        XCTAssertEqual(plan.instructions.get(at: 0), plan.instructions.get(at: 3))
        XCTAssertEqual(plan.instructions.get(at: 0), plan.instructions.get(at: 4))
        XCTAssertEqual(plan.instructions.get(at: 0), plan.instructions.get(at: 5))
        XCTAssertEqual(plan.instructions.get(at: 0), plan.instructions.get(at: 6))
        XCTAssertEqual(plan.instructions.get(at: 0), plan.instructions.get(at: 7))
        XCTAssertEqual(plan.instructions.get(at: 0), plan.instructions.get(at: 8))
        XCTAssertEqual(plan.instructions.get(at: 0), plan.instructions.get(at: 9))
        XCTAssertNil(plan.instructions.get(at: 10))
        XCTAssertNil(plan.instructions.get(at: 11))
        XCTAssertFalse(plan.instructions.isEnd(at: -3))
        XCTAssertFalse(plan.instructions.isEnd(at: -2))
        XCTAssertFalse(plan.instructions.isEnd(at: -1))
        XCTAssertFalse(plan.instructions.isEnd(at: 0))
        XCTAssertFalse(plan.instructions.isEnd(at: 1))
        XCTAssertFalse(plan.instructions.isEnd(at: 2))
        XCTAssertFalse(plan.instructions.isEnd(at: 3))
        XCTAssertFalse(plan.instructions.isEnd(at: 4))
        XCTAssertFalse(plan.instructions.isEnd(at: 5))
        XCTAssertFalse(plan.instructions.isEnd(at: 6))
        XCTAssertFalse(plan.instructions.isEnd(at: 7))
        XCTAssertFalse(plan.instructions.isEnd(at: 8))
        XCTAssertFalse(plan.instructions.isEnd(at: 9))
        XCTAssertTrue(plan.instructions.isEnd(at: 10))
        XCTAssertFalse(plan.instructions.isEnd(at: 11))
        
    }
    
    func testTimerPlanStage() throws {
        let a = TimerPlanStage(pourRate: 5, duration: 10)
        let b = TimerPlanStage(pourRate: 5, duration: 10)
        XCTAssertNotNil(a.id)
        XCTAssertNotEqual(a.id, b.id)
        XCTAssertEqual(a.pourRate, b.pourRate)
        XCTAssertEqual(a.duration, b.duration)
        XCTAssertNotEqual(a, b)
    }
    
    func testTimerPlans() throws {
        let a = TimerPlan(title: "Sample", stages: [])
        let b = TimerPlan(title: "Sample", stages: [])
        XCTAssertNotNil(a.id)
        XCTAssertNotEqual(a.id, b.id)
        XCTAssertEqual(a.stages.count, b.stages.count)
        XCTAssertNotEqual(a, b)
    }

    func testTimerInstruction() throws {
        let a = TimerInstruction(fromTime: 0, toTime: 10, fromMass: 0, toMass: 50)
        let b = TimerInstruction(fromTime: 0, toTime: 10, fromMass: 0, toMass: 50)
        let c = TimerInstruction(fromTime: 10, toTime: 35, fromMass: 50, toMass: 50)
        
        XCTAssertEqual(a.fromTime, 0)
        XCTAssertEqual(a.toTime, 10)
        XCTAssertEqual(a.fromMass, 0)
        XCTAssertEqual(a.toMass, 50)
        
        XCTAssertEqual(a, b)
        XCTAssertNotEqual(a, c)
        XCTAssertNotEqual(b, c)
        
        XCTAssertTrue(a.isPouring)
        XCTAssertFalse(c.isPouring)
        
        XCTAssertFalse(a.isResting)
        XCTAssertTrue(c.isResting)
        
        XCTAssertTrue(a.isPouringStart(at: 0))
        XCTAssertFalse(a.isRestingStart(at: 0))
        XCTAssertTrue(c.isRestingStart(at: 10))
        XCTAssertFalse(c.isPouringStart(at: 10))
        
        XCTAssertEqual(a.getMass(at: 0), 0)
        XCTAssertEqual(a.getMass(at: 5), 25)
        XCTAssertEqual(a.getMass(at: 10), 50)
        XCTAssertEqual(c.getMass(at: 10), 50)
        XCTAssertEqual(c.getMass(at: 25), 50)
        XCTAssertEqual(c.getMass(at: 35), 50)
    }
    
    /*
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }*/

}
