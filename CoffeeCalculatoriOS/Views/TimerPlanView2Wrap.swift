//
//  TimerPlanView2Wrap.swift
//  CoffeeCalculatoriOS
//
//  Created by Bill Paetzke on 5/7/20.
//  Copyright © 2020 Bill Paetzke. All rights reserved.
//

import SwiftUI

struct TimerPlanView2Wrap: View {
    
    @EnvironmentObject var model: TimerPlanModel // for watchos to work
    
    var plan: TimerPlan
    
    var body: some View {
        TimerPlanView2(plan: getBindable(plan))
    }
    
    private var defaultBinding: Binding<TimerPlan> {
        Binding.constant(TimerPlan(
            title: "Some Plan",
            stages: [
                TimerPlanStage(pourRate: 5, duration: 10),
                TimerPlanStage(pourRate: 0, duration: 25),
                TimerPlanStage(pourRate: 5, duration: 30),
                TimerPlanStage(pourRate: 0, duration: 60)
            ])
        )
    }
    
    private func getBindable(_ plan: TimerPlan) -> Binding<TimerPlan> {
        let index = self.model.plans.firstIndex {
            $0.id == plan.id
        }
        return getBindable(index)
    }
    
    private func getBindable(_ index: Int?) -> Binding<TimerPlan> {
        if let foundIndex = index {
            if foundIndex < 0 || foundIndex >= self.$model.plans.wrappedValue.count {
                print("plan index out of range")
                return defaultBinding
            }
            else {
                return self.$model.plans[foundIndex]
            }
        }
        else {
            return defaultBinding
        }
    }
}

struct TimerPlanView2Wrap_Previews: PreviewProvider {
    static var previews: some View {
        TimerPlanView2Wrap(
            plan: TimerPlan(
                title: "Some Plan",
                stages: [
                    TimerPlanStage(pourRate: 5, duration: 10),
                    TimerPlanStage(pourRate: 0, duration: 25)
                ]
            )
        )
    }
}
