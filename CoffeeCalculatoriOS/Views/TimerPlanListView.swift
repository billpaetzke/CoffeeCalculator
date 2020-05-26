//
//  TimerPlanListView.swift
//  CoffeeCalculatoriOS
//
//  Created by Bill Paetzke on 5/1/20.
//  Copyright © 2020 Bill Paetzke. All rights reserved.
//

import SwiftUI

struct DummyView: View {
    var body: some View {
        VStack {
            Text("Dummy view")
        }
        .navigationBarTitle("Dummy View")
    }
}

struct TimerPlanListView: View {
    
    @EnvironmentObject var timerPlanModel: TimerPlanModel
    
    @Binding var plans : [TimerPlan]
    
    @State private var isNewPlanMode = false
    
    var body: some View {
        
        List {
            ForEach(timerPlanModel.plans) { plan in
                
                
                
                NavigationLink(destination:
                    TimerPlanViewContainer(model: self.timerPlanModel, id: plan.id)
                ) {
                    VStack(alignment: .leading, spacing: 0) {
                        /*
                        if !plan.stages.isEmpty {
                            HStack(alignment: .top) {
                                
                                TimelineView(stages: plan.stages,
                                             containerWidth: 200,
                                             planScale: self.getScale(of: plan)
                                )
                            }
                        }*/
                        
                        Text("\(plan.title)").font(.headline)
                        
                        //Text("\(plan.pours)x @ \(plan.stages[0].pourRate)g/s").font(.subheadline)
                        Text("\(plan.pourMass)g -> \(plan.duration / 60)m\(plan.duration % 60)s").font(.footnote)
                    }
                    .contextMenu {
                        Button(action: {
                            
                            let newPlan = TimerPlan(plan)
                            let newPlanIndex = self.plans.firstIndex(of: plan)
                            if let insertAt = newPlanIndex {
                                self.plans.insert(newPlan, at: insertAt)
                            }
                            else {
                                self.plans.append(newPlan)
                            }
                            
                        }) {
                           HStack {
                                Text("Duplicate")
                                Image(systemName: "plus.square.on.square")
                            }
                        }
                    }
                }
                
            
            }
            .onMove { (source, destination) in
                self.plans.move(fromOffsets: source, toOffset: destination)
            }
            .onDelete { (atOffsets) in
                self.plans.remove(atOffsets: atOffsets)
            }
        }
        .navigationBarItems(trailing:
            HStack {
                EditButton()
                
            Button (action: { self.isNewPlanMode = true }) {
                Image(systemName: "square.and.pencil")
                }
        })
        .sheet(isPresented: $isNewPlanMode) {
            NavigationView {
                TimerPlanAddView(isPresented: self.$isNewPlanMode)
            }
            .environmentObject(self.timerPlanModel)
        }
    }
    
    private func getScale(of plan: TimerPlan) -> Double {
        let element = self.plans.max(by: { $0.duration < $1.duration })
        if let foundElement = element {
            return Double(plan.duration)/Double(foundElement.duration)
        }
        else {
            return 0.0
        }
    }
    
    private func getBindable(_ plan: TimerPlan) -> Binding<TimerPlan> {
        let index = self.plans.firstIndex(of: plan)
        if let foundIndex = index {
            return self.$plans[foundIndex]
        }
        else {
            return Binding.constant(TimerPlan(title: "", stages: []))
        }
    }
}

struct TimerPlanListView_Previews: PreviewProvider {
    static var previews: some View {
        TimerPlanListView(
            plans: .constant([
                TimerPlan(title: "Some Great Plan", stages: [
                    TimerPlanStage(pourRate: 5, duration: 10),
                    TimerPlanStage(pourRate: 0, duration: 25),
                    TimerPlanStage(pourRate: 4, duration: 20),
                    TimerPlanStage(pourRate: 0, duration: 30),
                ]),
                TimerPlan(title: "A Fine Plan", stages: [
                    TimerPlanStage(pourRate: 6, duration: 10),
                    TimerPlanStage(pourRate: 0, duration: 35),
                    TimerPlanStage(pourRate: 5, duration: 20),
                    TimerPlanStage(pourRate: 0, duration: 60),
                ])
            ])
        )
    }
}
