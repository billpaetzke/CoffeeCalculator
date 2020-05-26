//
//  TimerPlanView.swift
//  CoffeeCalculatoriOS
//
//  Created by Bill Paetzke on 4/2/20.
//  Copyright © 2020 Bill Paetzke. All rights reserved.
//

import SwiftUI

struct TimerPlanViewContainer : View {
    @ObservedObject var model: TimerPlanModel
    var id: TimerPlan.ID
    
    var body: some View {
        TimerPlanView(plan: get(id))
            .environmentObject(model)
    }
    
    private func get(_ id: TimerPlan.ID) -> TimerPlan {
        let plan = self.model.plans.first {
            $0.id == id
        }
        
        if let foundPlan = plan {
            return foundPlan
        }
        else {
            return TimerPlan(title: "", stages: [])
        }
    }
    
    private func getBindable(_ plan: TimerPlan) -> Binding<TimerPlan> {
        let index = self.model.plans.firstIndex(of: plan)
        return getBindable(index)
    }
    
    private func getBindable(_ id: TimerPlan.ID) -> Binding<TimerPlan> {
        let index = self.model.plans.firstIndex { $0.id == id }
        return getBindable(index)
    }
    
    private func getBindable(_ index: Int?) -> Binding<TimerPlan> {
        if let foundIndex = index {
            return self.$model.plans[foundIndex]
        }
        else {
            return Binding.constant(TimerPlan(title: "", stages: []))
        }
    }
}

struct TimerPlanView: View {
    
    @EnvironmentObject var brewPlanModel: BrewPlanModel
    
    var plan : TimerPlan
    
    @State private var isTimerMode = false
    
    var body: some View {
        
        EmptyView()
        //TimerStageListView(planTitle: $plan.title, stages: $plan.stages)
            .navigationBarTitle(plan.title)
            .navigationBarItems(trailing:
                HStack {
                    EditButton()
                    Button (action: {
                        self.isTimerMode = true
                        self.timerPlanModel.selectedPlan = self.plan
                        /*self.timerPlanModel.plans
                            .move(
                                fromOffsets: IndexSet([self.timerPlanModel.plans.firstIndex(of: self.plan)!]),
                                toOffset: 0
                            ) currently getting a tableview lowlevel uikit error */
                        /*
                         
                         self.$plans.wrappedValue.move(fromOffsets: IndexSet([self.plans.firstIndex(of: plan)!]), toOffset: 0)
                         */
                    }) {
                        Image(systemName: "timer")
                    }
                    
                   
                
                }
                
                
        )
            /*
        .sheet(isPresented: self.$isTimerMode) {
            NavigationView {
            TimerView(
                isPresented: self.$isTimerMode,
                areHapticsEnabled: self.$timerPlanModel.areHapticsEnabled,
                speechVolume: self.$timerPlanModel.speechVolume,
                instruction: self.plan.instructions.get(at: TimerHolder.sharedInstance.count)
            )
                .environmentObject(self.timerHolder)
                .environmentObject(self.brewPlanModel)
            }
        }*/
        
        
        
        
        /*TimerView(timerHolder: timerHolder,
         selectedPlan: $selectedPlan,
         areHapticsEnabled: $areHapticsEnabled,
         speechVolume:  $speechVolume,
         instruction: selectedPlan?.instructions.get(at: timerHolder.count))
         .opacity(timerHolder.state == .reset ? 0 : 1)*/
        
        
        
    }
    
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
    
    @EnvironmentObject var timerHolder: TimerHolder
    @EnvironmentObject var timerPlanModel : TimerPlanModel  // TODO check after Xcode 11.4 to see if this useless reference is no longer needed
}





struct TimerPlanView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TimerPlanView(
                plan: //.constant(
                    TimerPlan(
                        title: "preview",
                        stages: [
                            TimerPlanStage(pourRate: 5, duration: 17),
                            TimerPlanStage(pourRate: 0, duration: 35),
                            TimerPlanStage(pourRate: 5, duration: 20),
                            TimerPlanStage(pourRate: 0, duration: 35),
                            TimerPlanStage(pourRate: 5, duration: 18),
                            TimerPlanStage(pourRate: 0, duration: 35),
                            TimerPlanStage(pourRate: 5, duration: 19),
                            TimerPlanStage(pourRate: 0, duration: 61),
                    ]))
            //)
                .environmentObject(TimerHolder.sharedInstance)
                .environmentObject(BrewPlanModel())
                .environmentObject(TimerPlanModel(plans: [
                    TimerPlan(
                        title: "preview",
                        stages: [
                            TimerPlanStage(pourRate: 5, duration: 17),
                            TimerPlanStage(pourRate: 0, duration: 35),
                            TimerPlanStage(pourRate: 5, duration: 20),
                            TimerPlanStage(pourRate: 0, duration: 35),
                            TimerPlanStage(pourRate: 5, duration: 18),
                            TimerPlanStage(pourRate: 0, duration: 35),
                            TimerPlanStage(pourRate: 5, duration: 19),
                            TimerPlanStage(pourRate: 0, duration: 61),
                    ])
                ]))
        }
    }
}
