//
//  TimerStageEditView3Container.swift
//  CoffeeCalculatoriOS
//
//  Created by Bill Paetzke on 5/6/20.
//  Copyright © 2020 Bill Paetzke. All rights reserved.
//

import SwiftUI

struct TimerStageEditView3Wrap: View {
    
    @EnvironmentObject var model: TimerPlanModel
    var stage: TimerPlanStage
    var planId: TimerPlan.ID
    
    var body: some View {
        TimerStageEditView3(stage: getBindable(stage, for: planId))
            .environmentObject(model)
    }
    
    private var defaultBinding: Binding<TimerPlanStage> {
        Binding.constant(TimerPlanStage(pourRate: 0, duration: 0))
    }
    
    private func getBindable(_ stage: TimerPlanStage, for planId: TimerPlan.ID) -> Binding<TimerPlanStage> {
        if let parentIndex = self.model.plans.firstIndex(where: { $0.id == planId }) {
            let index = self.model.plans[parentIndex].stages.firstIndex {
                $0.id == stage.id
            }
            return getBindable(index, for: parentIndex)
        }
        
        print("plan index out of range for a given stage")
        return defaultBinding
    }
    
    private func getBindable(_ index: Int?, for parentIndex: Int) -> Binding<TimerPlanStage> {
        if let foundIndex = index {
            if foundIndex < 0 || foundIndex >= self.$model.plans[parentIndex].stages.wrappedValue.count {
                print("stage index out of range")
                return defaultBinding
            }
            else {
                return self.$model.plans[parentIndex].stages[foundIndex]
            }
        }
        else {
            return defaultBinding
        }
    }
}

struct TimerStageEditView3Wrap_Previews: PreviewProvider {
    static var previews: some View {
        TimerStageEditView3Wrap(
            stage: TimerPlanStage(pourRate: 5, duration: 10),
            planId: UUID()
        )
    }
}
