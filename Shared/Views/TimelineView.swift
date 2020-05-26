//
//  TimelineView.swift
//  CoffeeCalculator WatchKit Extension
//
//  Created by Bill Paetzke on 4/19/20.
//  Copyright © 2020 Bill Paetzke. All rights reserved.
//

import SwiftUI

struct TimelineView: View {
    
    var stages : [TimerPlanStage]
    
    var containerWidth : Double = 100
    
    var planScale : Double = 1.0
    
    let baseWidth = 20.0
    let baseHeight = 40.0
    
    let spacing : CGFloat = 3
    
    private func getTotalDuration(stages : [TimerPlanStage]) -> Int {
        if stages.isEmpty { return 0 }
        
        return stages.reduce(0, { x, y in x + y.duration })
    }
    
    private func getStageWidth(containerWidth:CGFloat, planScale:CGFloat, stageScale:CGFloat) -> CGFloat {
        containerWidth * planScale * stageScale
    }
    
    private func getStageScale(stage : TimerPlanStage, totalDuration: Int) -> Double {
        if totalDuration == 0 { return 0 }
        
        return Double(stage.duration) / Double(totalDuration)
    }
    
    var body: some View {
        
        HStack(spacing: spacing) {
            ForEach(stages) { stage in
                
                Capsule()
                    .foregroundColor(stage.pourRate > 0 ? Color.blue : Color.secondary)
                    .frame(
                        width: self.getStageWidth(
                            containerWidth: CGFloat(self.containerWidth) - (CGFloat(self.stages.count - 1) * self.spacing),
                        planScale: CGFloat(self.planScale),
                        stageScale: CGFloat(self.getStageScale(
                            stage: stage,
                            totalDuration: self.getTotalDuration(stages: self.stages))))
                )
            }
        }
    }
}


struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        TimelineView(stages: [
            TimerPlanStage(pourRate: 5, duration: 17),
            TimerPlanStage(pourRate: 0, duration: 35),
            TimerPlanStage(pourRate: 5, duration: 20),
            TimerPlanStage(pourRate: 0, duration: 35),
            TimerPlanStage(pourRate: 5, duration: 18),
            TimerPlanStage(pourRate: 0, duration: 35),
            TimerPlanStage(pourRate: 5, duration: 19),
            TimerPlanStage(pourRate: 0, duration: 61),
        ], containerWidth: 200)
            .frame(height: 20)
    }
}
