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
    @ObservedObject var model : TimerPlanModel
    
    var body: some View {
        
        let instruction = model.instructions.get(at: timerHolder.count)
        
        return VStack {
            
            if  instruction != nil {
                Text("\(instruction!.fromTime) to \(instruction!.toTime)s")
                Text("\(instruction!.fromMass) to \(instruction!.toMass)g")
            }
            
            Button(action: {
                
                if self.timerHolder.isRunning {
                    self.timerHolder.stop()
                    self.extendedSessionHolder.stop()
                    
                    if let activeComplications = CLKComplicationServer.sharedInstance().activeComplications {
                        for activeComplication in activeComplications {
                            CLKComplicationServer.sharedInstance().reloadTimeline(for: activeComplication)
                        }
                    }
                }
                else if self.timerHolder.startDate != nil {
                    self.timerHolder.reset()
                    
                    if let activeComplications = CLKComplicationServer.sharedInstance().activeComplications {
                        for activeComplication in activeComplications {
                            CLKComplicationServer.sharedInstance().reloadTimeline(for: activeComplication)
                        }
                    }
                }
                
                
            }) {
                Image(systemName: timerHolder.isRunning ? "stop" : "backward.end")
            }
        }.navigationBarTitle(timerHolder.startDate == nil ? "Timer" : "\(timerHolder.count)")
    }
    
    func format(second: TimeInterval) -> String? {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = Int(second) % 60 == 0 ? .dropLeading : .dropTrailing
        return formatter.string(from: second)
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(timerHolder: TimerHolder.sharedInstance,
                  extendedSessionHolder: ExtendedSessionHolder(),
                  model: TimerPlanModel(plan: TimerPlan(title: "Test", stages: [TimerPlanStage(pourRate: 5, duration: 10)])))
    }
}
