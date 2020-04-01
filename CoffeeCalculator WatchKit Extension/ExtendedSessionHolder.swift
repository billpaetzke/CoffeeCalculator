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

class ExtendedSessionHolder : NSObject, WKExtendedRuntimeSessionDelegate, AVSpeechSynthesizerDelegate {
    
    var watchSpecificSubToCount : AnyCancellable?
    var generalSubToCount : AnyCancellable?
    let synth = AVSpeechSynthesizer()
    //var extendedSessionBackgroundQueue: DispatchQueue = DispatchQueue(label: "extendedSessionBackgroundQueue")
    
    override init() {
        super.init()
        synth.delegate = self
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
    
    func watchSpecificSubscribeCount(timerCountPublisher : Published<Int>.Publisher, model : TimerInstructions) {
        self.watchSpecificSubToCount = timerCountPublisher
            .receive(on: RunLoop.current)
            .dropFirst() // the @Published seems to be a current value publisher, and we only want new values
            .sink(receiveValue: {
                count in
                
                //let nextPourTime = model.getNextPourStartTime(from: TimeInterval(count))
                //let nextRestTime = model.getNextRestStartTime(from: TimeInterval(count))
                let instructionNow = model.get(at: count)
                let instructionNext = model.get(at: count + 3) /* instruction 3 sec in future */
                let isEndTime = model.isEnd(at: count)
                
                if count == 0 || instructionNow?.isPouringStart(at: count) ?? false {
                    WKInterfaceDevice.current().play(.start)
                    
                }
                else if instructionNext != nil && instructionNext != instructionNow {
                    
                    let direction : WKHapticType = instructionNext!.isPouring ? .directionUp : .directionDown
                    WKInterfaceDevice.current().play(direction)
                    
                }
                else if instructionNow?.isRestingStart(at: count) ?? false
                {
                    WKInterfaceDevice.current().play(.stop)
                }
                else if isEndTime {
                    WKInterfaceDevice.current().play(.success)
                    
                }
                else if model.isEnd(at: count - 3) {
                    /* 3 seconds after end */
                    self.stop()
                }
            })
    }
    
    func generalSubscribeCount(timerCountPublisher : Published<Int>.Publisher, model : TimerInstructions, timerHolder: TimerHolder, spokenIntervalSec : TimeInterval) {
        self.generalSubToCount = timerCountPublisher
            .receive(on: RunLoop.current)
            .dropFirst() // the @Published seems to be a current value publisher, and we only want new values
            .sink(receiveValue: {
                count in
                
                self.subTimes.append(Date())
               
                let instructionNow = model.get(at: count)
                let instructionNext = model.get(at: count + 1)
                let isEndTime = model.isEnd(at: count)
                let isEndTimeNext = model.isEnd(at: count + 1)
                let isPouringStartNext : Bool = instructionNext?.isPouringStart(at: count + 1) ?? false
                let isPouring : Bool = instructionNow?.isPouring ?? false
                
                if count == -3 {
                    let utter = AVSpeechUtterance(string: "OK")
                    utter.rate = AVSpeechUtteranceDefaultSpeechRate * 1.25
                    utter.volume = Float(0.0)
                    self.synth.speak(utter)
                }
                else if isPouringStartNext || isEndTimeNext {
                    let utter = AVSpeechUtterance(string: "OK")
                    utter.rate = AVSpeechUtteranceDefaultSpeechRate * 1.25
                    utter.volume = Float(1.0)
                    self.synth.speak(utter)
                }
                else if isEndTime {
                    let utter = AVSpeechUtterance(string: ".")
                    utter.rate = AVSpeechUtteranceDefaultSpeechRate * 1.25
                    utter.volume = Float(1.0)
                    self.synth.speak(utter)
                }
                else if isPouring {
                     
                    let expectedBrewMass = instructionNow!.getMass(at: count)
                    var speechText = self.getSpeechText(mass: expectedBrewMass)
                    
                    let isRestingStartUpNext = instructionNext?.isRestingStart(at: count + 1) ?? false
                    if isRestingStartUpNext {
                        let expectedBrewMassUpNext = instructionNext!.getMass(at: count + 1)
                        speechText += ", OK \(self.getSpeechText(mass: expectedBrewMassUpNext))."
                    }
                    
                    let utter = AVSpeechUtterance(string: speechText)
                    utter.rate = AVSpeechUtteranceDefaultSpeechRate * 1.25
                    utter.pitchMultiplier = 1.0
                    utter.volume = Float(1.0)
                    //utter.voice = AVSpeechSynthesisVoice(language: "ja-jp")//en-us")//es-mx")
                    self.synth.speak(utter)
                    
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
    
    private var subTimes : [Date] = []
    private var speechStartTimes : [Date] = []
    private var speechFinishTimes : [Date] = []
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        speechStartTimes.append(Date())
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        speechFinishTimes.append(Date())
    }
}
