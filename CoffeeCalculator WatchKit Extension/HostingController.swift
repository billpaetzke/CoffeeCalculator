//
//  HostingController.swift
//  CoffeeCalculator WatchKit Extension
//
//  Created by Bill Paetzke on 1/15/20.
//  Copyright © 2020 Bill Paetzke. All rights reserved.
//

import WatchKit
import Foundation
import SwiftUI
import AVFoundation

class HostingController: WKHostingController<AnyView> {
    
    let complicationHandler = ComplicationHandler(timerStatePublisher: TimerHolder.sharedInstance.$state)
    //var extendedSessionHolder : ExtendedSessionHolder!
    var extendedRuntimeSessionHandler: ExtendedRuntimeSessionHandler!
    var hapticsHandler: HapticsHandler!
    var timerSubscriber : TimerSubscriber!
    let timerPlanModel = TimerPlanModel(plans: [
        TimerPlan(title: "Rao", stages: [
            TimerPlanStage(pourRate: 5, duration: 17),
            TimerPlanStage(pourRate: 0, duration: 35),
            TimerPlanStage(pourRate: 5, duration: 20),
            TimerPlanStage(pourRate: 0, duration: 35),
            TimerPlanStage(pourRate: 5, duration: 18),
            TimerPlanStage(pourRate: 0, duration: 35),
            TimerPlanStage(pourRate: 5, duration: 19),
            TimerPlanStage(pourRate: 0, duration: 61),
        ]),
        TimerPlan(title: "4:6", stages: [
            TimerPlanStage(pourRate: 6, duration: 10),
            TimerPlanStage(pourRate: 0, duration: 35),
            TimerPlanStage(pourRate: 6, duration: 10),
            TimerPlanStage(pourRate: 0, duration: 35),
            TimerPlanStage(pourRate: 6, duration: 10),
            TimerPlanStage(pourRate: 0, duration: 35),
            TimerPlanStage(pourRate: 6, duration: 10),
            TimerPlanStage(pourRate: 0, duration: 35),
            TimerPlanStage(pourRate: 6, duration: 10),
            TimerPlanStage(pourRate: 0, duration: 20),
        ]),
        TimerPlan(title: "Dre", stages: [
            TimerPlanStage(pourRate: 4, duration: 9),
            TimerPlanStage(pourRate: 0, duration: 23),
            TimerPlanStage(pourRate: 4, duration: 16),
            TimerPlanStage(pourRate: 0, duration: 21),
            TimerPlanStage(pourRate: 4, duration: 15),
            TimerPlanStage(pourRate: 0, duration: 16),
            TimerPlanStage(pourRate: 4, duration: 13),
            TimerPlanStage(pourRate: 0, duration: 16),
            TimerPlanStage(pourRate: 4, duration: 15),
            TimerPlanStage(pourRate: 0, duration: 16),
        ]),
        TimerPlan(title: "Aero Joe", stages: [
            TimerPlanStage(pourRate: 20, duration: 10),
            TimerPlanStage(pourRate: 0, duration: 40),
            TimerPlanStage(pourRate: 0, duration: 10),
            TimerPlanStage(pourRate: 0, duration: 5),
            TimerPlanStage(pourRate: 0, duration: 30),
        ])
    ])
    let brewPlanModel = BrewPlanModel()
    
    override var body: AnyView {
        
        let audioSession = AVAudioSession.sharedInstance()
        do { // setCategory must be set to playback for background audio to be allowed
            try audioSession.setCategory(AVAudioSession.Category.playback, options: .mixWithOthers)
        } catch {
          print("audioSession properties weren't set because of an error.")
        }

        extendedRuntimeSessionHandler = ExtendedRuntimeSessionHandler(
            session: ExtendedSessionHolder(),
            timerStatePublisher: TimerHolder.sharedInstance.$state,
            timerCountPublisher: TimerHolder.sharedInstance.$count,
            timerPlanPublisher: timerPlanModel.$selectedPlan)
        hapticsHandler = HapticsHandler(hapticsEnabledPublisher: timerPlanModel.$areHapticsEnabled,
                                        timerCountPublisher: TimerHolder.sharedInstance.$count,
                                        timerPlanPublisher: timerPlanModel.$selectedPlan)
        timerSubscriber = TimerSubscriber(
            speechVolumePublisher: timerPlanModel.$speechVolume,
            timerCountPublisher: TimerHolder.sharedInstance.$count,
            timerPlanPublisher: timerPlanModel.$selectedPlan)
        
        return
            AnyView(
                ContentView(
                    timerHolder: TimerHolder.sharedInstance,
                    timerPlanModel: timerPlanModel
                )
                .environmentObject(brewPlanModel)
            )
    }
}
