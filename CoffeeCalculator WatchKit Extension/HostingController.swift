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
    override var body: AnyView {
        
        let audioSession = AVAudioSession.sharedInstance()
        do { // setCategory must be set to playback for background audio to be allowed
            try audioSession.setCategory(AVAudioSession.Category.playback, options: .mixWithOthers)
        } catch {
          print("audioSession properties weren't set because of an error.")
        }
        
        return AnyView(
            ContentView()
            .environmentObject(BrewTimerHolder())
        )
    }
}
