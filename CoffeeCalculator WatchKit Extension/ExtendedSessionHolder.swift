//
//  ExtendedSessionHolder.swift
//  CoffeeCalculator WatchKit Extension
//
//  Created by Bill Paetzke on 2/11/20.
//  Copyright © 2020 Bill Paetzke. All rights reserved.
//

import Foundation
import WatchKit
import Combine
import AVFoundation

class ExtendedSessionHolder : NSObject, WKExtendedRuntimeSessionDelegate {
    
    var watchSpecificSubToCount : AnyCancellable?
    var generalSubToCount : AnyCancellable?
    let synth = AVSpeechSynthesizer()
    
    func watchSpecificSubscribeCount(timerCountPublisher : Published<Int>.Publisher, model : TimerViewModel) {
        self.watchSpecificSubToCount = timerCountPublisher
            .receive(on: RunLoop.current)
            .dropFirst() // the @Published seems to be a current value publisher, and we only want new values
            .sink(receiveValue: {
                count in
                
                if (count == 0 || count == model.firstPourDurationSec + Int(model.bloomDurationSec)) {
                    WKInterfaceDevice.current().play(.start)
                    
                    /* something to do on start?
                    let clkServer = CLKComplicationServer.sharedInstance()
                    let complications = clkServer.activeComplications
                    if (complications != nil && complications!.count > 0)
                    {
                        clkServer.reloadTimeline(for: (complications?[0])!)
                    }*/
                }
                else if (count >= model.firstPourDurationSec - 3 && count < model.firstPourDurationSec) {
                    WKInterfaceDevice.current().play(.directionDown)
                }
                else if (count < 0
                    || (count >= model.firstPourDurationSec + Int(model.bloomDurationSec) - 3 && count < model.firstPourDurationSec + Int(model.bloomDurationSec))
                    )
                {
                    WKInterfaceDevice.current().play(.directionUp)
                }
                else if (count == model.firstPourDurationSec)
                {
                    WKInterfaceDevice.current().play(.stop)
                }
                else if (count >= model.totalDurationSec - 3 && count < model.totalDurationSec)
                {
                    WKInterfaceDevice.current().play(.directionDown)
                }
                else if (count == model.totalDurationSec) {
                    WKInterfaceDevice.current().play(.success)
                }
                else if (count >= model.totalDurationSec + 60) {
                    WKInterfaceDevice.current().play(.start)
                }
                else if (count >= model.totalDurationSec + 180) // not sure if this code block runs or acts as intended; need to test
                {
                    self.stop()
                }
            })
    }
    
    func generalSubscribeCount(timerCountPublisher : Published<Int>.Publisher, model : TimerViewModel, timerHolder: TimerHolder) {
        self.generalSubToCount = timerCountPublisher
            .receive(on: RunLoop.current)
            .dropFirst() // the @Published seems to be a current value publisher, and we only want new values
            .sink(receiveValue: {
                count in
                
                if (count == -3) {
                    let utter = AVSpeechUtterance(string: "OK")
                    utter.volume = Float(0.0)
                    self.synth.speak(utter)
                }
                else {
                
                    let stageNum = model.getStageNum(durationSec: count)
                    
                    if (count == model.firstPourDurationSec
                        || count == model.totalDurationSec
                        || count == model.firstPourDurationSec + Int(model.bloomDurationSec.rounded())
                        || (count % (Int(model.spokenIntervalSec.rounded())) == 0 && (stageNum == 1 || stageNum == 3))
                        )
                    {
                        let expectedBrewMass = model.getExpectedBrewMass(durationSec: count)
                        let utter = AVSpeechUtterance(string: self.getSpeechText(mass: Int(expectedBrewMass.rounded())))
                        utter.volume = Float(1.0)
                        self.synth.speak(utter)
                    }
                }
                /*
                if (count >= model.totalDurationSec)
                {
                    timerHolder.stop()
                }*/
            })
    }
    
    func getSpeechText(mass:Int) -> String
    {
        if (mass % 100 < 10) // i.e. 100-109, 200-209, etc.
        {
            return String(mass) // "one hundred nine"
        }
        
        if (mass / 100 > 0) // i.e. 110-199, 210-299, etc.
        {
            return String(mass / 100) + " " + String(mass % 100) // "one twenty nine"
        }
        
        return String(mass % 100) // 10-99 // "twenty nine"
        
    }
    
    
    private var runtimeSession = WKExtendedRuntimeSession()
    
    func start() {
        if (runtimeSession.state == .invalid)
        {
            runtimeSession = WKExtendedRuntimeSession()
        }
        runtimeSession.delegate = self
        runtimeSession.start()
    }
    
    func stop() {
        if (runtimeSession.state == .running)
        {
            runtimeSession.invalidate()
        }
    }
    
    func extendedRuntimeSessionDidStart(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        // Track when your session starts.
    }
    
    func extendedRuntimeSessionWillExpire(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        // Finish and clean up any tasks before the session ends.
    }
    func extendedRuntimeSession(_ extendedRuntimeSession: WKExtendedRuntimeSession, didInvalidateWith reason: WKExtendedRuntimeSessionInvalidationReason, error: Error?) {
        // Track when your session ends.
        // Also handle errors here.
    }
}
