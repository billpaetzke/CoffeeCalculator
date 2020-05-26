//
//  TimerView.swift
//  CoffeeCalculatoriOS
//
//  Created by Bill Paetzke on 4/2/20.
//  Copyright © 2020 Bill Paetzke. All rights reserved.
//

import SwiftUI

struct TimerView: View {
    
    @EnvironmentObject var brewPlanModel : BrewPlanModel
    @EnvironmentObject var timerHolder : TimerHolder
    
    @Binding var areHapticsEnabled : Bool
    @Binding var speechVolume : Float
    
    var instruction : TimerInstruction?
    var dismiss: (() -> Void)?
    
    @State private var showCalcSheet = false
    @State private var showCaffeineSheet = false

    
    var body: some View {
        
        VStack {
            
            Text("\( format( second: Double(timerHolder.count) ) )").font(Font.system(size: 96))
            Group {
                if instruction == nil {
                    Text("-- to --s")
                    Text("-- to --g")
                }
                else {
                    Text("\(instruction!.fromTime) to \(instruction!.toTime)s")
                    Text("\(instruction!.fromMass) to \(instruction!.toMass)g")
                }
            }.font(Font.system(size: 48))
            
            Spacer()
            
            Button(action: {
                
                switch self.timerHolder.state {
                case .reset:
                    self.timerHolder.start()
                case .running:
                    self.timerHolder.stop()
                case .stopped:
                    self.timerHolder.reset()
                }
            }) {
                
                Image(systemName: getTimerButtonImageSystemName())
                    .font(.largeTitle)
            }
            
            Spacer()
            
            Group {
                
                HStack {
                    Image(systemName: "speaker.fill")
                    Slider(value: $speechVolume, in: 0...1)
                    Image(systemName: "speaker.3.fill")
                }
                Divider()
                Toggle(isOn: $areHapticsEnabled) {
                    Image(systemName: areHapticsEnabled ? "bolt.fill" : "bolt.slash.fill")
                }.fixedSize()
            }.padding(.horizontal)
            
            
            
        }
        .navigationBarTitle("Some plan: \(timerHolder.count)")
        .sheetBarItems(
            leading:
            Button(action: {
                self.timerHolder.reset()
                (self.dismiss ?? {})()
            }) {
                Image(systemName: "xmark.circle")
                    .padding(.trailing)
            }
            , trailing:
            /*HStack {
             Button (action:{self.showCalcSheet = true}) {
             Image(systemName: "plus.slash.minus")
             }.sheet(isPresented: $showCalcSheet) {
             CalculatorView()
             .navigationBarTitle("X")
             .environmentObject(self.brewPlanModel)
             }.padding()*/
            
            Button (action: {self.showCaffeineSheet = true}) {
                Image(systemName: "square.and.pencil")
                    .padding(.leading)
            }.sheet(isPresented: $showCaffeineSheet) {
                CaffeineView(isPresented: self.$showCaffeineSheet)
                    .navigationBarTitle("X")
            }.opacity(timerHolder.state == .stopped ? 1 : 0)
            /*}.opacity(timerHolder.state == .stopped ? 1 : 0)
             .padding()*/
        )
    }
    
    func getTimerButtonImageSystemName() -> String {
        switch timerHolder.state {
        case .reset:
            return "play"
        case .running:
            return "stop"
        case .stopped:
            return "backward.end"
        }
    }
    
    func format(second: TimeInterval) -> String {
        if second == -4 {
            return "----"
        }
        else if second == -3 {
            return "---"
        }
        else if second == -2 {
            return "--"
        }
        else if second == -1 {
            return "-"
        }
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = Int(second) % 60 == 0 ? .dropLeading : .dropTrailing
        let formatted = formatter.string(from: second)
        return formatted ?? "--"
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
        //NavigationView {
        TimerView(
            areHapticsEnabled: .constant(true),
            speechVolume: .constant(1.0),
            instruction: TimerInstruction(fromTime: 0, toTime: 10, fromMass: 0, toMass: 40),
            dismiss: nil
        ).environmentObject(BrewPlanModel())
            .environmentObject(TimerHolder.sharedInstance)
        //}
        
    }
}
