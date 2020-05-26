//
//  TimerSubscriber.swift
//  CoffeeCalculator
//
//  Created by Bill Paetzke on 4/2/20.
//  Copyright © 2020 Bill Paetzke. All rights reserved.
//

import Foundation
import Combine
import AVFoundation

final class TimerSubscriber : NSObject, AVSpeechSynthesizerDelegate, ObservableObject {
    
    let synth = AVSpeechSynthesizer()
    
    private var speechVolume : Float = 1.0
        
    init(speechVolumePublisher: Published<Float>.Publisher,
         timerCountPublisher : Published<Int>.Publisher,
         timerPlanPublisher : Published<TimerPlan?>.Publisher) {
        
        super.init()
        synth.delegate = self
        
        speechVolumeSubscriber(speechVolumePublisher: speechVolumePublisher)
        speechSubscriber(timerCountPublisher: timerCountPublisher, timerPlanPublisher: timerPlanPublisher)
    }
    
    private var speechVolumeSubscriber: AnyCancellable?
    
    func speechVolumeSubscriber(speechVolumePublisher: Published<Float>.Publisher) {
            self.speechVolumeSubscriber = speechVolumePublisher
                .receive(on: DispatchQueue.main)
                .subscribe(on: DispatchQueue.global(qos: .userInteractive))
                .sink(receiveValue: {
                    speechVolume in
                
    //                Thread.sleep(forTimeInterval: 3)
                
                    self.speechVolume = speechVolume
                    //print("speechVolume changed to \(speechVolume)")
            })
        }
    
    private var speechSubscriber: AnyCancellable?
    
    func speechSubscriber(timerCountPublisher : Published<Int>.Publisher, timerPlanPublisher : Published<TimerPlan?>.Publisher) {
        self.speechSubscriber = Publishers.CombineLatest(timerCountPublisher, timerPlanPublisher)
            .filter({ $1 != nil})
            .receive(on: DispatchQueue.main)
            .subscribe(on: DispatchQueue.global(qos: .userInteractive))
            //.dropFirst() // the @Published seems to be a current value publisher, and we only want new values
            .sink(receiveValue: {
                count, plan in
                
                self.subTimes.append(Date())
                
                print("Speech Sub: \(count)s \(plan!.title)")
                
                guard let instructions = plan?.instructions else { return }
                                
                 let instructionNow = instructions.get(at: count)
                 let instructionNext = instructions.get(at: count + 1)
                 let isEndTime = instructions.isEnd(at: count)
                 let isEndTimeNext = instructions.isEnd(at: count + 1)
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
                     utter.volume = Float(self.speechVolume)
                     self.synth.speak(utter)
                 }
                 else if isEndTime {
                     let utter = AVSpeechUtterance(string: ".")
                     utter.rate = AVSpeechUtteranceDefaultSpeechRate * 1.25
                     utter.volume = Float(self.speechVolume)
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
                     utter.volume = Float(self.speechVolume)
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
