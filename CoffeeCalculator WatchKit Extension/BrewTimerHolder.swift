//
//  BrewTimerHolder.swift
//  CoffeeCalculator WatchKit Extension
//
//  Created by Bill Paetzke on 1/23/20.
//  Copyright © 2020 Bill Paetzke. All rights reserved.
//

import SwiftUI
import Combine
import AVFoundation

class BrewTimerHolder : NSObject, ObservableObject, WKExtendedRuntimeSessionDelegate {
    
    
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
    
    var timer : Timer!
    let objectWillChange = PassthroughSubject<BrewTimerHolder,Never>()
    var count = 0 {
        didSet {
            self.objectWillChange.send(self)
        }
    }
    
    var isRunning = false {
        didSet {
            self.objectWillChange.send(self)
        }
    }
    
    var expectedBrewMass = 0 {
        didSet {
            self.objectWillChange.send(self)
        }
    }
    
    var iteration = -3 {
        didSet {
            self.objectWillChange.send(self)
        }
    }
    
    var startTime : Date?
    
    let synth = AVSpeechSynthesizer()
    
    var runtimeSession = WKExtendedRuntimeSession()
    
    var areAllStepsCompleted = false
    
    var pourRate = 5.0
    
    var firstPourWait = 30.0
    
    var stepDurationSec = 3
    
    var stepOffset = 0
    
    func start(coffeeMass: Double, waterCoffeeRatio: Double) {
        
        var firstPourAmount: Double {
            (coffeeMass * 2.0 / pourRate).rounded(.up) * pourRate
        }
        
        var firstPourAmountInt: Int {
            Int(firstPourAmount.rounded())
        }
        
        var firstPourDurationSec: Int {
            Int((firstPourAmount / pourRate).rounded())
        }
        
        var waterMass : Double {
            waterCoffeeRatio * coffeeMass
        }
        
        var finalPourAmount: Int {
            Int(waterMass.rounded())
        }
        
        var finalPourDurationSec: Int {
            Int(((waterMass - firstPourAmount) / pourRate).rounded())
        }
        
        var totalDurationSec: Int {
            firstPourDurationSec + Int(firstPourWait.rounded()) + finalPourDurationSec
        }
        
        let clkServer = CLKComplicationServer.sharedInstance()
        let complications = clkServer.activeComplications
        if (complications != nil && complications!.count > 0)
        {
            clkServer.reloadTimeline(for: (complications?[0])!)
        }
        
        self.timer?.invalidate()
        
        if (runtimeSession.state == .invalid)
        {
            runtimeSession = WKExtendedRuntimeSession()
        }
        runtimeSession.delegate = self
        runtimeSession.start()
        
        self.areAllStepsCompleted = false
        self.expectedBrewMass = 0
        self.iteration = -3
        self.isRunning = true
        self.stepOffset = 0
        
        WKInterfaceDevice.current().play(.directionDown) // first of three haptics to start
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
            _ in
            
            if (self.areAllStepsCompleted)
            {
                self.autoStop()
                return;
            }
            
            self.iteration += 1
            
            if (self.iteration < 0)
            {
                WKInterfaceDevice.current().play(.directionDown)
            }
            else if (self.iteration == 0)
            {
                self.startTime = Date()
                
                WKInterfaceDevice.current().play(.start)
                
                let utter = AVSpeechUtterance(string: self.getSpeechText(mass: self.expectedBrewMass))
                //utter.voice = AVSpeechSynthesisVoice(language: "en-US")
                utter.volume = Float(1.0)
                self.synth.speak(utter)
            }
            else {
                if (self.iteration % self.stepDurationSec == self.stepOffset && (self.iteration <= firstPourDurationSec || self.iteration >= firstPourDurationSec + Int(self.firstPourWait.rounded()) + self.stepDurationSec))
                {
                    self.expectedBrewMass += self.stepDurationSec * Int(self.pourRate.rounded())
                    
                    if (self.iteration == firstPourDurationSec)
                    {
                        WKInterfaceDevice.current().play(.stop)
                    }
                    
                    if (self.iteration == totalDurationSec) {
                        WKInterfaceDevice.current().play(.success)
                        self.areAllStepsCompleted = true
                        self.expectedBrewMass = Int(waterMass.rounded())
                    }
                    
                    let utter = AVSpeechUtterance(string: self.getSpeechText(mass: self.expectedBrewMass))
                    //utter.voice = AVSpeechSynthesisVoice(language: "en-US")
                    utter.volume = Float(1.0)
                    self.synth.speak(utter)
                }
                else if (self.iteration == firstPourDurationSec && self.iteration % self.stepDurationSec != 0) {
                    self.stepOffset = self.iteration % self.stepDurationSec
                    self.expectedBrewMass += self.stepOffset * Int(self.pourRate.rounded())
                    
                    WKInterfaceDevice.current().play(.stop)
                    
                    let utter = AVSpeechUtterance(string: self.getSpeechText(mass: self.expectedBrewMass))
                    //utter.voice = AVSpeechSynthesisVoice(language: "en-US")
                    utter.volume = Float(1.0)
                    self.synth.speak(utter)
                }
                else if (self.iteration == totalDurationSec && self.iteration % self.stepDurationSec != self.stepOffset) {

                    self.stepOffset = self.iteration % self.stepDurationSec
                    //self.expectedBrewMass += self.stepDurationSec * Int(self.pourRate.rounded())
                    self.expectedBrewMass = Int(waterMass.rounded())
                    
                    
                    WKInterfaceDevice.current().play(.success)
                    self.areAllStepsCompleted = true
                    
                    let utter = AVSpeechUtterance(string: self.getSpeechText(mass: self.expectedBrewMass))
                    //utter.voice = AVSpeechSynthesisVoice(language: "en-US")
                    utter.volume = Float(1.0)
                    self.synth.speak(utter)
                }
                else if (self.iteration >= firstPourDurationSec + Int(self.firstPourWait.rounded()) - 3 /* for 3 plays */ && self.iteration < firstPourDurationSec + Int(self.firstPourWait.rounded()))
                {
                    WKInterfaceDevice.current().play(.directionDown)
                }
                else if (self.iteration == firstPourDurationSec + Int(self.firstPourWait.rounded()))
                {
                    WKInterfaceDevice.current().play(.start)
                    
                    let utter = AVSpeechUtterance(string: self.getSpeechText(mass: self.expectedBrewMass))
                    //utter.voice = AVSpeechSynthesisVoice(language: "en-US")
                    utter.volume = Float(1.0)
                    self.synth.speak(utter)
                }
            }
        }
    }
    
    func manualStop() {
        
        autoStop()
        self.timer?.invalidate()
    }
    
    func autoStop() {
        
        self.isRunning = false
        
        runtimeSession.invalidate()
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
}

