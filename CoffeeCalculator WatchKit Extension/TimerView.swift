//
//  TimerView.swift
//  CoffeeCalculator WatchKit Extension
//
//  Created by Bill Paetzke on 1/21/20.
//  Copyright © 2020 Bill Paetzke. All rights reserved.
//

import SwiftUI

struct TimerView: View {
    
    @ObservedObject var timerHolder : TimerHolder
    var extendedSessionHolder : ExtendedSessionHolder
    @ObservedObject var timerViewModel : TimerViewModel
    //@State private var buttonText = "Start"
    //@State private var title = "title"
    
    var body: some View {
        VStack {
            
            //if (timerViewModel.getStageNum(durationSec: timerHolder.count) == 1)
            if !timerHolder.isRunning && timerHolder.startDate == nil
            {
                HStack {
                    VStack(alignment: .leading) {
                        
                        
                        ForEach(1...3, id: \.self) { stageNum in
                            Text(String(Int(self.timerViewModel.getStageMassMin(stageNum: stageNum).rounded()))
                                + " -> " +
                            String(Int(self.timerViewModel.getStageMassMax(stageNum: stageNum).rounded())))
                        }
                        
                        Text("grams")
                        
                    }
                    VStack(alignment: .trailing) {
                        
                        
                        ForEach(1...3, id: \.self) { stageNum in
                            Text(
                                self.format(
                                    second:TimeInterval(
                                        self.timerViewModel.getStageDurationSec(
                                            stageNum: stageNum
                                        )
                                    )
                                )
                                ?? "z"
                            )
                        }
                        
                        Text("\(format(second:TimeInterval(timerViewModel.totalDurationSec)) ?? "w")")
                        .fontWeight(.bold)
                    }
                }
            }
            else {
                VStack {
                      
                    Text(
                        String(Int(timerViewModel.getStageMassMin(stageNum: timerViewModel.getStageNum(durationSec: timerHolder.count)).rounded()))
                        + " -> " +
                        String(Int(timerViewModel.getStageMassMax(stageNum: timerViewModel.getStageNum(durationSec: timerHolder.count)).rounded()))
                    )
                    
                    Text(String(Int(timerViewModel.getExpectedBrewMass(durationSec: timerHolder.count).rounded())))
                        .font(.title)
                    
                    Text("grams").font(.footnote)
                }
            }
            
            
            
            HStack {
                OptionsButton(boundValue: self.$timerViewModel.pourRate, from: 3, by: 1, over: 4)
                OptionsButton(boundValue: self.$timerViewModel.bloomDurationSec, from: 30, by: 5, over: 4)
                    .font(.footnote)
                
                Button(action: {
                    if self.timerHolder.isRunning {
                        self.timerHolder.stop()
                        self.extendedSessionHolder.stop()
                    }
                    else {
                        if (self.timerHolder.startDate == nil) {
                            self.extendedSessionHolder.start()
                            self.extendedSessionHolder.watchSpecificSubscribeCount(timerCountPublisher: self.timerHolder.$count, model: self.timerViewModel)
                            self.extendedSessionHolder.generalSubscribeCount(timerCountPublisher: self.timerHolder.$count, model: self.timerViewModel, timerHolder: self.timerHolder)
                            self.timerHolder.start()
                        }
                        else {
                            self.timerHolder.reset()
                        }
                    }
                }) {
                    Image(systemName: timerHolder.isRunning ? "stop.fill" : (timerHolder.startDate == nil ? "play.fill" : "backward.end.fill"))
                }
                
                OptionsButton(boundValue: self.$timerViewModel.spokenIntervalSec, from: 2, by: 1, over: 4)
                
            }
        }
        .navigationBarTitle(getNavBarTitle(startDate: timerHolder.startDate, durationSec: timerHolder.count))
        /*.onReceive(timerHolder.$count, perform: { count in
            self.title = self.getNavBarTitle(durationSec: count)
        })*/
    }
    
    func format(second: TimeInterval) -> String? {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = Int(second) % 60 == 0 ? .dropLeading : .dropTrailing
        return formatter.string(from: second)
    }
    
    func getStageTimeRemainingSec(durationSec: Int) -> Int {
        if (durationSec < 0) {
            return abs(durationSec)
        }
        
        if (durationSec < timerViewModel.firstPourDurationSec) {
            return durationSec - timerViewModel.firstPourDurationSec
        }
        
        if (durationSec < timerViewModel.firstPourDurationSec + Int(timerViewModel.bloomDurationSec.rounded())) {
            return durationSec - timerViewModel.firstPourDurationSec - Int(timerViewModel.bloomDurationSec.rounded())
        }
            
        return timerViewModel.firstPourDurationSec + Int(timerViewModel.bloomDurationSec.rounded()) + timerViewModel.finalPourDurationSec - durationSec
    }
    
    func getStageTimeRemaining(durationSec: Int) -> String {
        
        return format(second: TimeInterval(getStageTimeRemainingSec(durationSec: durationSec))) ?? "y"
    }
    
    func getNavBarTitle(startDate : Date?, durationSec: Int) -> String {
        
        if (startDate == nil)
        {
            return "0/3) " + (format(second: 3) ?? "q")
        }
        
        if (self.timerViewModel.getStageNum(durationSec: durationSec) == 4)
        {
            let di = DateInterval(start: startDate!, end: Date())
            return format(second: di.duration) ?? "x"
        }
        
        return String(self.timerViewModel.getStageNum(durationSec: durationSec)) + "/3) " + getStageTimeRemaining(durationSec: durationSec)
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(timerHolder: TimerHolder(),
                  extendedSessionHolder: ExtendedSessionHolder(),
                  timerViewModel: TimerViewModel(massModel: CalculatorViewModel()))
    }
}
