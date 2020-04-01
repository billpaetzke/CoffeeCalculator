//
//  TimerPlanView.swift
//  CoffeeCalculator WatchKit Extension
//
//  Created by Bill Paetzke on 2/28/20.
//  Copyright © 2020 Bill Paetzke. All rights reserved.
//

import SwiftUI

struct TimerPlanView: View {
    
    @ObservedObject var timerHolder : TimerHolder
    var extendedSessionHolder : ExtendedSessionHolder
    
    var formatterOne : NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.maximumFractionDigits = 1
        f.minimumFractionDigits = 1
        f.roundingMode = .halfUp
        
        return f
    }()
    
    private func formatOne(_ p: Double) -> String {
        formatterOne.string(from: NSNumber(value: p)) ?? "-"
    }
    
    var formatterZero : NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.maximumFractionDigits = 0
        f.minimumFractionDigits = 0
        f.roundingMode = .halfUp
        
        return f
    }()
    
    private func formatZero(_ p: Double) -> String {
        formatterZero.string(from: NSNumber(value: p)) ?? "-"
    }
    
    @State private var timerMode = false
    @State private var selectedModel = TimerPlanModel(plan: TimerPlan(title: "", stages: []))
        
    var body: some View {
        
        ZStack {
            
            TimerView(timerHolder: timerHolder, extendedSessionHolder: extendedSessionHolder, model: selectedModel)
                .opacity(timerHolder.startDate != nil ? 1 : 0)
            
            ScrollView {
                ForEach(timerPlans) { plan in
                    Button (action: {
                             
                        self.selectedModel = TimerPlanModel(plan: plan)
                        self.timerMode = true
                        
                        if self.timerHolder.isRunning {
                            self.timerHolder.stop()
                            self.extendedSessionHolder.stop()
                        }
                        else {
                            if (self.timerHolder.startDate == nil) {
                                self.extendedSessionHolder.start()
                                self.extendedSessionHolder.watchSpecificSubscribeCount(timerCountPublisher: self.timerHolder.$count, model: self.selectedModel.instructions)
                                self.extendedSessionHolder.generalSubscribeCount(timerCountPublisher: self.timerHolder.$count, model: self.selectedModel.instructions, timerHolder: self.timerHolder, spokenIntervalSec: 1.0)
                                self.timerHolder.start()
                            }
                            else {
                                self.timerHolder.reset()
                            }
                        }
                        
                        if let activeComplications = CLKComplicationServer.sharedInstance().activeComplications {
                            for activeComplication in activeComplications {
                                CLKComplicationServer.sharedInstance().reloadTimeline(for: activeComplication)
                            }
                        }
                        
                    }) {
                    VStack(alignment: .leading) {
                        Text("\(plan.title)").font(.headline)
                        Text("\(plan.pours)x @ \(plan.stages[0].pourRate)g/s").font(.subheadline)
                        Text("\(plan.pourMass)g -> \(plan.duration / 60)m\(plan.duration % 60)s")
                    }
                    }
                        
                    
                }
            }
            .opacity(timerHolder.startDate != nil ? 0 : 1)
        }
        
        
    }
}

struct TimerPlanStage : Identifiable {
    let id = UUID()
    var pourRate : Int
    var duration : Int
}

struct TimerPlan : Identifiable {
    let id = UUID()
    var title : String
    var stages : [TimerPlanStage]
    
    var pours : Int {
        stages.filter { $0.pourRate > 0 }.count
    }
    
    var pourMass : Int {
        stages.reduce(0, { x, y in x + y.pourRate * y.duration })
    }
    
    var duration : Int {
        stages.reduce(0, { x, y in x + y.duration })
    }
}

struct TimerInstruction : Equatable {
    var fromTime : Int
    var toTime : Int
    var fromMass : Int
    var toMass : Int
    
    var isPouring : Bool {
        toMass > fromMass
    }
    
    var isResting : Bool {
        !isPouring
    }
    
    func isRestingStart(at time : Int) -> Bool {
        time == fromTime && isResting
    }
    
    func isPouringStart(at time : Int) -> Bool {
        time == fromTime && isPouring
    }
    
    func getMass(at time : Int) -> Int {
        fromMass + Int((Double((toMass - fromMass) * (time - fromTime)) / Double(toTime - fromTime)).rounded())
    }
}

struct TimerInstructions {
    private let instructions : [TimerInstruction]
    
    init(plan: TimerPlan) {
        self.instructions = Self.buildFrom(stages: plan.stages)
    }
    
    private static func buildFrom(stages: [TimerPlanStage]) -> [TimerInstruction]{
        var instructions = [TimerInstruction]()
        
        var time = 0
        var mass = 0
        for stage in stages {
            let toTime = time + stage.duration
            let toMass = mass + stage.pourRate * stage.duration
            
            instructions.append(
                TimerInstruction(fromTime: time, toTime: toTime, fromMass: mass, toMass: toMass)
            )
            time = toTime
            mass = toMass
        }
        
        return instructions
    }
    
    func get(at time : Int) -> TimerInstruction? {
        instructions.filter { $0.fromTime <= time && time < $0.toTime }.first
    }
    
    func isEnd(at time : Int) -> Bool {
        guard let instruction = instructions.last else {
            return false
        }
        
        return instruction.toTime == time
    }
}

final class TimerPlanModel : ObservableObject {
    
    private let timerPlan : TimerPlan
    let instructions : TimerInstructions
    
    init(plan: TimerPlan) {
        self.timerPlan = plan
        self.instructions = TimerInstructions(plan: plan)
    }
}

let timerPlans = [
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
    TimerPlan(title: "Aero", stages: [
        TimerPlanStage(pourRate: 6, duration: 5),
        TimerPlanStage(pourRate: 0, duration: 15),
        TimerPlanStage(pourRate: 10, duration: 17),
        TimerPlanStage(pourRate: 0, duration: 60),
        TimerPlanStage(pourRate: 0, duration: 23),
    ])
]

struct TimerPlanView_Previews: PreviewProvider {
    static var previews: some View {
        TimerPlanView(timerHolder: TimerHolder.sharedInstance, extendedSessionHolder: ExtendedSessionHolder())
    }
}
