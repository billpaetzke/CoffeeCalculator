//
//  TimerHolderTest.swift
//  CoffeeCalculatoriOSTests
//
//  Created by Bill Paetzke on 4/22/20.
//  Copyright © 2020 Bill Paetzke. All rights reserved.
//

import XCTest
@testable import CoffeeCalculatoriOS
import Combine

class TimerHolderTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testInit() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let a = TimerHolder()
        
        XCTAssertEqual(a.count, -3)
        XCTAssertNil(a.startDate)
        XCTAssertNil(a.stopDate)
        XCTAssertEqual(a.state, TimerHolder.State.reset)
        
    }
    
    func testStart() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let a = TimerHolder()
        
        let preStartTime = Date()
        a.start()
        let postStartTime = Date()
        let prepostInterval = preStartTime.distance(to: postStartTime)
        
        XCTAssertEqual(a.count, -3)
        XCTAssertNotNil(a.startDate)
        XCTAssertGreaterThanOrEqual(a.startDate!, preStartTime.addingTimeInterval(3))
        XCTAssertLessThanOrEqual(a.startDate!, postStartTime.addingTimeInterval(3))
        XCTAssertLessThan(prepostInterval, 0.2)
        XCTAssertNil(a.stopDate)
        XCTAssertEqual(a.state, TimerHolder.State.running)
    }
    
    func testStartStop() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let a = TimerHolder()
        
        
        a.start()
        
        let preStopTime = Date()
        a.stop()
        let postStopTime = Date()
        let prepostInterval = preStopTime.distance(to: postStopTime)
        
        XCTAssertEqual(a.count, -3)
        XCTAssertNotNil(a.stopDate)
        XCTAssertGreaterThanOrEqual(a.stopDate!, preStopTime)
        XCTAssertLessThanOrEqual(a.stopDate!, postStopTime)
        XCTAssertLessThan(prepostInterval, 0.2)
        XCTAssertNotNil(a.startDate)
        XCTAssertLessThan(a.startDate!.addingTimeInterval(-3), a.stopDate!)
        XCTAssertEqual(a.state, TimerHolder.State.stopped)
    }
    
    func testStartStopReset() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let a = TimerHolder()
        
        a.start()
        a.stop()
        a.reset()
        
        XCTAssertEqual(a.count, -4)
        XCTAssertNil(a.stopDate)
        XCTAssertNil(a.startDate)
        XCTAssertEqual(a.state, TimerHolder.State.reset)
    }
    
    func testPublisherCountInit() throws {
        
        let expectation = XCTestExpectation(description: "async sink test")
        
        let a = TimerHolder()
        let publisher = a.$count
        let cancellable = publisher.sink { value in
            print(".sink() received \(String(describing: value))")
            XCTAssertEqual(value, -3)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(cancellable)
    }
    
    func testPublisherCountReset() throws {
        
        let expectation = XCTestExpectation(description: "async sink test")
        
        let a = TimerHolder()
        let publisher = a.$count
        let cancellable = publisher
            .dropFirst(2) // drop these: init fires -3, start() fires -3
            .sink { value in
                print(".sink() received \(String(describing: value))")
                XCTAssertEqual(value, -4)
                expectation.fulfill()
        }
        a.start()
        a.stop()
        a.reset()
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(cancellable)
    }
    
    func testPublisherStateInit() throws {
        
        let expectation = XCTestExpectation(description: "async sink test")
        
        let a = TimerHolder()
        let publisher = a.$state
        let cancellable = publisher.sink { value in
            print(".sink() received \(String(describing: value))")
            XCTAssertEqual(value, TimerHolder.State.reset)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(cancellable)
    }
    
    func testPublisherStateRunning() throws {
        
        let expectation = XCTestExpectation(description: "async sink test")
        
        let a = TimerHolder()
        let publisher = a.$state
        let cancellable = publisher
            .dropFirst()
            .sink { value in
                print(".sink() received \(String(describing: value))")
                XCTAssertEqual(value, TimerHolder.State.running)
                expectation.fulfill()
        }
        a.start()
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(cancellable)
    }
    
    func testPublisherStateStopped() throws {
        
        let expectation = XCTestExpectation(description: "async sink test")
        
        let a = TimerHolder()
        let publisher = a.$state
        let cancellable = publisher
            .dropFirst(2)
            .sink { value in
                print(".sink() received \(String(describing: value))")
                XCTAssertEqual(value, TimerHolder.State.stopped)
                expectation.fulfill()
        }
        a.start()
        a.stop()
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(cancellable)
    }
    
    func testPublisherStateReset() throws {
        
        let expectation = XCTestExpectation(description: "async sink test")
        
        let a = TimerHolder()
        let publisher = a.$state
        let cancellable = publisher
            .dropFirst(3)
            .sink { value in
                print(".sink() received \(String(describing: value))")
                XCTAssertEqual(value, TimerHolder.State.reset)
                expectation.fulfill()
        }
        a.start()
        a.stop()
        a.reset()
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(cancellable)
    }
    
    /*
     func testSimpleSink() {
     // setup
     let expectation = XCTestExpectation(description: "async sink test")
     let examplePublisher = Just(5)
     // validate
     let cancellable = examplePublisher.sink { value in
     print(".sink() received \(String(describing: value))")
     XCTAssertEqual(value, 5)
     expectation.fulfill()
     }
     wait(for: [expectation], timeout: 5.0)
     XCTAssertNotNil(cancellable)
     }*/
    /*
     func testPerformanceExample() throws {
     // This is an example of a performance test case.
     self.measure {
     // Put the code you want to measure the time of here.
     }
     }*/
    
}
