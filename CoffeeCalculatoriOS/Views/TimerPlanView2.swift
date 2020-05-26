//
//  TimerPlanView2.swift
//  CoffeeCalculatoriOS
//
//  Created by Bill Paetzke on 5/6/20.
//  Copyright © 2020 Bill Paetzke. All rights reserved.
//

import SwiftUI

struct TimerPlanView2: View {
    @EnvironmentObject var timerHolder: TimerHolder // for isTimerMode sheet
    @EnvironmentObject var model: TimerPlanModel // for watchos to work
    @Binding var plan: TimerPlan
    
    @State private var isTimerMode = false
    
    var body: some View {
        VStack {
            
            TextField("Title", text: $plan.title)
            
            List {
                ForEach(plan.stages) { stage in
                    NavigationLink(destination: TimerStageEditView3Wrap(stage: stage, planId: self.plan.id)
                         .environmentObject(self.model) // for watchos to work
                    ) {
                        HStack {
                            Text("\(stage.duration)s")
                            Text("@")
                            Text("\(stage.pourRate)g/s")
                            Spacer()
                            Text("\(stage.duration * stage.pourRate)g")
                        }
                    }.isDetailLink(false) // possibly prevents the underlying table view redraw warning
                }
                .onMove { (source, destination) in
                    self.plan.stages.move(fromOffsets: source, toOffset: destination)
                }
                .onDelete { (source) in
                    self.plan.stages.remove(atOffsets: source)
                }
            }
        }
        .navigationBarTitle("\(plan.title) (\(plan.stages.count))")
        .navigationBarItems(trailing:
            HStack {
                EditButton()
                Button (action: {
                    self.isTimerMode = true
                    self.model.selectedPlan = self.plan
                        /*self.timerPlanModel.plans
                            .move(
                                fromOffsets: IndexSet([self.timerPlanModel.plans.firstIndex(of: self.plan)!]),
                                toOffset: 0
                            ) currently getting a tableview lowlevel uikit error */
                        
                      /*
                    self.$model.plans.wrappedValue.move(
                        fromOffsets: IndexSet([
                            self.model.plans.firstIndex(of: self.plan)!
                        ]),
                        toOffset: 0
                    )*/
                         
                }) {
                    Image(systemName: "timer")
                        .padding(.leading)
                }
            }
        )
        .sheet(isPresented: $isTimerMode) {
            TimerView(
                areHapticsEnabled: self.$model.areHapticsEnabled,
                speechVolume: self.$model.speechVolume,
                instruction: self.plan.instructions.get(at: TimerHolder.sharedInstance.count),
                dismiss: { self.isTimerMode = false }
            )
            .environmentObject(self.timerHolder)
        }
    }
}

struct TimerPlanView2_Previews: PreviewProvider {
    static var previews: some View {
        TimerPlanView2(
            plan: .constant(TimerPlan(
                title: "Some Plan",
                stages: [
                    TimerPlanStage(pourRate: 5, duration: 10),
                    TimerPlanStage(pourRate: 0, duration: 25),
                    TimerPlanStage(pourRate: 5, duration: 30),
                    TimerPlanStage(pourRate: 0, duration: 60)
            ]))
        )
    }
}
