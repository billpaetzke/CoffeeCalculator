//
//  BrewTimerView.swift
//  CoffeeCalculator WatchKit Extension
//
//  Created by Bill Paetzke on 1/23/20.
//  Copyright © 2020 Bill Paetzke. All rights reserved.
//

import SwiftUI

struct BrewTimerView: View {
    @EnvironmentObject var timerHolder: BrewTimerHolder
    @Binding var beverageMass: Double
    @Binding var waterCoffeeRatio: Double
    
    private var pourRate: Double {
        timerHolder.pourRate
    }
    
    private var firstPourWait: Double {
        timerHolder.firstPourWait
    }
    
    private var coffeeMass : Double {
        beverageMass / (waterCoffeeRatio - 2.0)
    }
        
    private var waterMass : Double {
        waterCoffeeRatio * coffeeMass
    }
    
    private var firstPourAmount: Double {
        (coffeeMass * 2.0 / pourRate).rounded(.up) * pourRate
    }
    
    private var firstPourAmountInt: Int {
        Int(firstPourAmount.rounded())
    }
    
    private var firstPourDurationSec: Int {
        Int((firstPourAmount / pourRate).rounded())
    }
    
    private var firstPourWaitInt: Int {
        Int(firstPourWait.rounded())
    }
    
    private var finalPourAmount: Int {
        Int(waterMass.rounded())
    }
    
    private var finalPourDurationSec: Int {
        Int(((waterMass - firstPourAmount) / pourRate).rounded())
    }
    
    func getStageNum(durationSec:Int) -> Int {
        if (durationSec < 0) {
            return 0
        }
        
        if (durationSec < firstPourDurationSec) {
            return 1
        }
        
        if (durationSec < firstPourDurationSec + firstPourWaitInt) {
            return 2
        }
            
        return 3
    }
    
    func getMassOfStage(stageNum : Int) -> String {
        if (stageNum == 0) { return "0 -> 0" }
        else if (stageNum == 1) { return "0 -> " + String(firstPourAmountInt) }
        else if (stageNum == 2) { return String(firstPourAmountInt) + " -> " + String(firstPourAmountInt) }
        else { return String(firstPourAmountInt) + " -> " + String(finalPourAmount) }
    }
    
    func getStageTimeRemainingSec(durationSec: Int) -> Int {
        if (durationSec < 0) {
            return abs(durationSec)
        }
        
        if (durationSec < firstPourDurationSec) {
            return durationSec - firstPourDurationSec
        }
        
        if (durationSec < firstPourDurationSec + firstPourWaitInt) {
            return durationSec - firstPourDurationSec - firstPourWaitInt
        }
            
        return firstPourDurationSec + firstPourWaitInt + finalPourDurationSec - durationSec
    }
    
    func getStageTimeRemaining(durationSec: Int) -> String {
        
        return format(second: TimeInterval(getStageTimeRemainingSec(durationSec: durationSec))) ?? "0"
    }
    
    func format(second: TimeInterval) -> String? {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = Int(second) % 60 == 0 ? .dropLeading : .dropTrailing
        return formatter.string(from: second)
    }
    
    func getNavBarTitle() -> String {
        if (getStageNum(durationSec: self.timerHolder.iteration) == 3 && !self.timerHolder.isRunning && (self.timerHolder.startTime != nil))
        {
            let di = DateInterval(start: self.timerHolder.startTime!, end: Date())
            return format(second: di.duration) ?? "0:00"
        }
        
        return String(getStageNum(durationSec: self.timerHolder.iteration)) + "/3) " + getStageTimeRemaining(durationSec: self.timerHolder.iteration)
    }
    
    
    var body: some View {
        
        VStack {
            
            if (getStageNum(durationSec: self.timerHolder.iteration) == 0)
            {
                HStack {
                    VStack(alignment: .leading) {
                        Text("grams")
                        Text(getMassOfStage(stageNum: 1))
                        Text(getMassOfStage(stageNum: 2))
                        Text(getMassOfStage(stageNum: 3))
                        
                    }
                    VStack(alignment: .trailing) {
                        Text("duration")
                        Text(String(format(second:TimeInterval(firstPourDurationSec)) ?? "0"))
                        Text(String(format(second:TimeInterval(firstPourWaitInt)) ?? "0"))
                        Text(String(format(second:TimeInterval(finalPourDurationSec)) ?? "0"))
                    }
                }
            }
            else {
                VStack {
                      
                    Text(getMassOfStage(stageNum: getStageNum(durationSec: self.timerHolder.iteration)))
                    
                    Text(String(self.timerHolder.expectedBrewMass)).font(.title)
                    
                    Text("grams").font(.footnote)
                }
            }
            

                
                Button(action: {
                    if (self.timerHolder.isRunning) {
                        self.timerHolder.manualStop()
                    }
                    else {
                        self.timerHolder.start(coffeeMass: self.coffeeMass, waterCoffeeRatio: self.waterCoffeeRatio)
                    }
                }) {
                    
                    Image(systemName: self.timerHolder.isRunning ? "stop.fill" : "play.fill")
                    
                }
            
            
        }.navigationBarTitle(getNavBarTitle())
    }
}

struct BrewTimerView_Previews: PreviewProvider {
    
    static var previews: some View {
      PreviewWrapper()
    }

    struct PreviewWrapper: View {
        @State private var beverageMass : Double = 300.0
        @State private var waterCoffeeRatio : Double = 18.0

        var body: some View {
            BrewTimerView(beverageMass: $beverageMass,
                          waterCoffeeRatio: $waterCoffeeRatio)
                .environmentObject(BrewTimerHolder())
        }
    }
}
