//
//  TimerHolder.swift
//  CoffeeCalculator WatchKit Extension
//
//  Created by Bill Paetzke on 2/11/20.
//  Copyright © 2020 Bill Paetzke. All rights reserved.
//

import Foundation
import Combine

final class TimerHolder : ObservableObject {
    //var timer : Timer!
    
    enum State : Equatable {
        case reset
        case running
        case stopped
        /*
        case stopped(Date)
        
        func isStopped() -> Bool {
            switch self {
            case .stopped(_):
                return true
            default:
                return false
            }
        }*/
    }
    
    private var cancellableTimer : AnyCancellable?

    private(set) var startDate : Date?
    private(set) var stopDate : Date?
    
    @Published private(set) var count = -3
    @Published private(set) var state : State = .reset
    
    static let sharedInstance = TimerHolder()
    
    func start() {
       /* timer?.invalidate()
        
        count = -3
        startDate = Date().addingTimeInterval(3)

        timer = Timer(timeInterval: 1, repeats: true) {
            _ in
            
            let interval = self.startDate!.distance(to: Date())
            self.count = Int(interval.rounded())
            
            //self.count += 1
            
            if (self.count == 1800) {
                self.stop()
                self.reset()
            }
        }
        RunLoop.current.add(timer, forMode: .common)

        state = .running*/
        
        cancellableTimer?.cancel()
        
        if startDate == nil {
            count = -3
            startDate = Date().addingTimeInterval(3)
        }
        else {
            let timeElapsed = startDate!.distance(to: stopDate!)
            startDate = Date().addingTimeInterval(-timeElapsed)
            
        }

        cancellableTimer = Timer.publish(every: 1, on: .current, in: .common)
            .autoconnect()
            .sink(receiveValue: {
                currentDate in
                
                self.count = self.getTimeIntervalAsInt(from: self.startDate!, to: currentDate)
                
                if (self.count == 1800) {
                    self.stop()
                    self.reset()
                }
            })

        state = .running
    }
    
    private func getTimeIntervalAsInt(from startDate: Date, to endDate: Date) -> Int {
        let interval = startDate.distance(to: endDate)
        return Int(interval.rounded())
    }
    
    func stop() {

        //timer?.invalidate()
        cancellableTimer?.cancel()
        stopDate = Date()
        state = .stopped//(Date())
    }
    
    func reset() {
        cancellableTimer = nil
        startDate = nil
        stopDate = nil
        count = -4 // experiment
        state = .reset
    }
}
