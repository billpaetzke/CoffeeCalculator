//
//  TimerView.swift
//  CoffeeCalculator WatchKit Extension
//
//  Created by Bill Paetzke on 1/21/20.
//  Copyright © 2020 Bill Paetzke. All rights reserved.
//

import SwiftUI

struct TimerView: View {
        
    @EnvironmentObject var brewPlanModel : BrewPlanModel
    
    @ObservedObject var timerHolder : TimerHolder
    
    @Binding var selectedPlan : TimerPlan?
    @Binding var areHapticsEnabled : Bool
    @Binding var speechVolume : Float
    
    @State private var isSpeechVolumeFocused = false
    @State private var showCalcSheet = false
    @State private var showCaffeineSheet = false
    
    var instruction : TimerInstruction?
    
    var body: some View {
        
        VStack {
            
            HStack {
                
                Image(systemName: getSpeakerSymbol(at: speechVolume))
                    .opacity(isSpeechVolumeFocused ? 1.0 : 0.3)
                    .focusable(true, onFocusChange: {
                        isFocused in
                        self.isSpeechVolumeFocused = isFocused
                    })
                    .digitalCrownRotation($speechVolume, from: 0.0, through: 1.0, by: 0.05, sensitivity: .low, isContinuous: false, isHapticFeedbackEnabled: true)
                    .id(timerHolder.state == .running)
                Spacer()
                Image(systemName: areHapticsEnabled ? "bolt.fill" : "bolt.slash.fill")
                    .onTapGesture {
                        self.areHapticsEnabled.toggle()
                    }
            }.padding()
            Spacer()
            
            ZStack {
                if  instruction != nil && timerHolder.state == .running {
                    VStack {
                        Text("\(instruction!.fromTime) to \(instruction!.toTime)s")
                        Text("\(instruction!.fromMass) to \(instruction!.toMass)g")
                    }
                }
                
                HStack {
                    Button (action:{self.showCalcSheet = true}) {
                        Image(systemName: "plus.slash.minus")
                    }.sheet(isPresented: $showCalcSheet) {
                        CalculatorView()
                            .navigationBarTitle("X")
                            .environmentObject(self.brewPlanModel)
                    }
                    
                    Button (action: {self.showCaffeineSheet = true}) {
                        Image(systemName: "square.and.pencil")
                    }.sheet(isPresented: $showCaffeineSheet) {
                        CaffeineView(isPresented: self.$showCaffeineSheet)
                            .navigationBarTitle("X")
                    }
                }.opacity(timerHolder.state == .stopped ? 1 : 0)
            }
            
            Button(action: {
                
                switch self.timerHolder.state {
                case .running:
                    self.timerHolder.stop()
                case .stopped:
                    self.timerHolder.reset()
                    self.selectedPlan = nil
                case .reset:
                    break; // do nothing; this would be an exception; should never be here
                }
                
            }) {
                Image(systemName: timerHolder.state == .running ? "stop" : "backward.end")
            }
        }.navigationBarTitle(timerHolder.state == .reset ? "Paetzke ☕️" : "\(timerHolder.count)")
    }
    
    func format(second: TimeInterval) -> String? {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = Int(second) % 60 == 0 ? .dropLeading : .dropTrailing
        return formatter.string(from: second)
    }
    
    func getSpeakerSymbol(at speechVolume : Float) -> String {
        
        if (speechVolume == Float.zero) { return "speaker.slash.fill" }
        else if (speechVolume <= 0.33) { return "speaker.1.fill" }
        else if (speechVolume <= 0.67) { return "speaker.2.fill" }
        else { return "speaker.3.fill" }
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(
            timerHolder: TimerHolder.sharedInstance,
            selectedPlan: .constant(TimerPlan(title: "preview", stages: [])),
            areHapticsEnabled: .constant(true),
            speechVolume: .constant(1.0),
            instruction: TimerInstruction(fromTime: 0, toTime: 10, fromMass: 0, toMass: 40)
        ).environmentObject(BrewPlanModel())
    }
}
