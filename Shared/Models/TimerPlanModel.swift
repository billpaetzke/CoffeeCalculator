//
//  TimerPlanModel.swift
//  CoffeeCalculator
//
//  Created by Bill Paetzke on 4/2/20.
//  Copyright © 2020 Bill Paetzke. All rights reserved.
//

import Foundation

final class TimerPlanModel : ObservableObject {
    
    @Published var plans : [TimerPlan]
    
    // specific to timer
    @Published var selectedPlan : TimerPlan?
    @Published var areHapticsEnabled : Bool = true
    @Published var speechVolume : Float = 1.0
        
    init(plans: [TimerPlan]) {
        self.plans = plans
    }
}

struct TimerPlanStage : Identifiable, Equatable, Hashable {
    internal let id = UUID()
    var pourRate : Int
    var duration : Int
}

struct TimerPlan : Identifiable, Equatable, Hashable {
    
    init(title: String, stages: [TimerPlanStage]) {
        self.title = title
        self.stages = stages
        self.instructions = TimerInstructions(plan: self)
    }
    
    let id = UUID()
    var title : String
    var stages : [TimerPlanStage] {
        willSet {
            //print("will set stages for " + title)
        }
        didSet {
            //print("begin did set stages for " + title)
            instructions = TimerInstructions(plan: self)
           // print("end did set stages for " + title)
           // print("stages count: \(stages.count)")
        }
    }
    private(set) var instructions : TimerInstructions!
    
    var pours : Int {
        stages.filter { $0.pourRate > 0 }.count
    }
    
    var pourMass : Int {
        stages.reduce(0, { x, y in x + y.pourRate * y.duration })
    }
    
    var duration : Int {
        stages.reduce(0, { x, y in x + y.duration })
    }
    
    /// Creates a copy of a plan with a new ID
    init(_ plan: TimerPlan) {
        self.init(title: plan.title, stages: plan.stages)
    }
}

struct TimerInstruction : Equatable, Hashable {
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

struct TimerInstructions : Equatable, Hashable {
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
/*
var timerPlans = [
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
]*/
