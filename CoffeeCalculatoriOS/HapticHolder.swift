//
//  HapticHolder.swift
//  CoffeeCalculatoriOS
//
//  Created by Bill Paetzke on 4/2/20.
//  Copyright © 2020 Bill Paetzke. All rights reserved.
//

import Foundation
import CoreHaptics

final class HapticHolder {
    
    enum HapticType : CaseIterable {
        case start
        case stop
        case directionUp
        case directionDown
        case success
    }
    
    // Haptic Engine & State:
    private var engine: CHHapticEngine!
    private var supportsHaptics = CHHapticEngine.capabilitiesForHardware().supportsHaptics
    //private var supportsAudio = CHHapticEngine.capabilitiesForHardware().supportsAudio
    private var engineNeedsStart = true
    private var patternEvents: [HapticType : [CHHapticEvent]]!
    
    func createAndStartHapticEngine() {
        guard supportsHaptics else { return }
        
        // Create and configure the haptic engine.
        do {
            engine = try CHHapticEngine()
        } catch let error {
            fatalError("Haptic Engine Creation Error: \(error)")
        }
        
        // The stopped handler alerts engine stoppage.
        engine.stoppedHandler = { reason in
            print("Stop Handler: The haptic engine stopped for reason: \(reason.rawValue)")
            
            /*switch reason {
             
             }*/
            // Handle possible reasons here.
            // Indicate that the next time the app requires a haptic,
            // the app must call engine.start().
            self.engineNeedsStart = true
        }
        
        engine.resetHandler = {
            self.engineNeedsStart = true
        }
        
        patternEvents = buildPatternEvents()
        
        // tactile haptics are useless for now (but audio haptics remain on)
        engine.isMutedForHaptics = true
        
        // Start haptic engine to prepare for use.
        start()
    }
    
    private func start() {
        guard supportsHaptics else { return }
               // Start haptic engine to prepare for use.
         do {
             try engine.start()
             // Indicate that the next time the app requires a haptic,
             // the app doesn't need to call engine.start().
             engineNeedsStart = false
         } catch let error {
             fatalError("Haptic Engine Start Error: \(error)")
         }
    }
    
    func stop() {
        guard supportsHaptics else { return }
        
        engine.stop()
    }
    
    func play(_ type: HapticType) {
        guard supportsHaptics else { return }
        guard let events = patternEvents[type] else { return }
        if engineNeedsStart {
            start()
        }
        
        // convert those events into a pattern and play it immediately
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }
    
    private func buildPatternEvents() -> [HapticType : [CHHapticEvent]] {
        var collection = [HapticType : [CHHapticEvent]]()
        
        for hapticType in HapticType.allCases {
            
            var events = [CHHapticEvent]()
            
            switch hapticType {
            case .directionDown:
                events.append(CHHapticEvent(eventType: .hapticTransient, parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(1)),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(1))
                ], relativeTime: 0))
                
                events.append(CHHapticEvent(eventType: .audioContinuous, parameters: [
                    CHHapticEventParameter(parameterID: .audioVolume, value: Float(1)),
                    CHHapticEventParameter(parameterID: .decayTime, value: Float(0.5)),
                    CHHapticEventParameter(parameterID: .sustained, value: 0),
                ], relativeTime: 0))
                
                events.append(CHHapticEvent(eventType: .hapticTransient, parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(0.5)),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(0.5))
                ], relativeTime: 0.1))
                
                events.append(CHHapticEvent(eventType: .audioContinuous, parameters: [
                    CHHapticEventParameter(parameterID: .audioVolume, value: Float(1)),
                    CHHapticEventParameter(parameterID: .decayTime, value: Float(0.5)),
                    CHHapticEventParameter(parameterID: .sustained, value: 0),
                ], relativeTime: 0.1))
            case.directionUp:
                events.append(CHHapticEvent(eventType: .hapticTransient, parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(0.5)),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(0.5))
                ], relativeTime: 0))
                
                events.append(CHHapticEvent(eventType: .audioContinuous, parameters: [
                    CHHapticEventParameter(parameterID: .audioVolume, value: Float(1)),
                    CHHapticEventParameter(parameterID: .decayTime, value: Float(0.5)),
                    CHHapticEventParameter(parameterID: .sustained, value: 0),
                ], relativeTime: 0))
                
                events.append(CHHapticEvent(eventType: .hapticTransient, parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(1)),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(1))
                ], relativeTime: 0.1))
                
                events.append(CHHapticEvent(eventType: .audioContinuous, parameters: [
                    CHHapticEventParameter(parameterID: .audioVolume, value: Float(1)),
                    CHHapticEventParameter(parameterID: .decayTime, value: Float(0.5)),
                    CHHapticEventParameter(parameterID: .sustained, value: 0),
                ], relativeTime: 0.1))
            case .start:
                events.append(CHHapticEvent(eventType: .hapticTransient, parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(0.5)),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(0.5))
                ], relativeTime: 0))
                
                events.append(CHHapticEvent(eventType: .audioContinuous, parameters: [
                    CHHapticEventParameter(parameterID: .audioVolume, value: Float(1)),
                    CHHapticEventParameter(parameterID: .decayTime, value: Float(0.5)),
                    CHHapticEventParameter(parameterID: .sustained, value: 0),
                ], relativeTime: 0))
                
            case .stop:
                events.append(CHHapticEvent(eventType: .hapticTransient, parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(0.5)),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(0.5))
                ], relativeTime: 0))
                
                events.append(CHHapticEvent(eventType: .audioContinuous, parameters: [
                    CHHapticEventParameter(parameterID: .audioVolume, value: Float(1)),
                    CHHapticEventParameter(parameterID: .decayTime, value: Float(0.5)),
                    CHHapticEventParameter(parameterID: .sustained, value: 0),
                ], relativeTime: 0))
                
                events.append(CHHapticEvent(eventType: .hapticTransient, parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(0.5)),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(0.5))
                ], relativeTime: 0.5))
                
                events.append(CHHapticEvent(eventType: .audioContinuous, parameters: [
                    CHHapticEventParameter(parameterID: .audioVolume, value: Float(1)),
                    CHHapticEventParameter(parameterID: .decayTime, value: Float(0.5)),
                    CHHapticEventParameter(parameterID: .sustained, value: 0),
                ], relativeTime: 0.5))
            case .success:
                events.append(CHHapticEvent(eventType: .hapticTransient, parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(0.5)),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(0.5))
                ], relativeTime: 0))
                
                events.append(CHHapticEvent(eventType: .audioContinuous, parameters: [
                    CHHapticEventParameter(parameterID: .audioVolume, value: Float(1)),
                    CHHapticEventParameter(parameterID: .decayTime, value: Float(0.5)),
                    CHHapticEventParameter(parameterID: .sustained, value: 0),
                ], relativeTime: 0))
                
                events.append(CHHapticEvent(eventType: .hapticTransient, parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(0.5)),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(0.5))
                ], relativeTime: 0.1))
                
                events.append(CHHapticEvent(eventType: .audioContinuous, parameters: [
                    CHHapticEventParameter(parameterID: .audioVolume, value: Float(1)),
                    CHHapticEventParameter(parameterID: .decayTime, value: Float(0.5)),
                    CHHapticEventParameter(parameterID: .sustained, value: 0),
                ], relativeTime: 0.1))
            }
            
            collection[hapticType] = events
        }
        
        return collection
    }
    
    
}
