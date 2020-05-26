//
//  TimerPlanListView1.swift
//  CoffeeCalculatoriOS
//
//  Created by Bill Paetzke on 5/6/20.
//  Copyright © 2020 Bill Paetzke. All rights reserved.
//

import SwiftUI

struct TimerPlanListView1: View {
    
    @EnvironmentObject var model: TimerPlanModel // needed for sheet close buttons to work; needed for nav link for watchos
    @Binding var plans: [TimerPlan]
    
    @State private var isNewPlanMode = false
    @State private var selectedPlan: TimerPlan?
    
    var body: some View {
        VStack {
            List {
                ForEach(plans) { plan in
                    NavigationLink(destination: TimerPlanView2Wrap(plan: plan)
                        .environmentObject(self.model) // needed for watchos
                    ) {
                        VStack {
                            Text(plan.title).font(.headline)
                            Text("\(plan.pourMass)g -> \(plan.duration / 60)m\(plan.duration % 60)s").font(.footnote)
                            
                        }
                        .contextMenu {
                            TimerPlanRowContextMenuView(selectedPlan: self.$selectedPlan, plans: self.$plans, plan: plan)
                        }
                    }.isDetailLink(false) // needed for inner view to avoid infinite drawing loop of its nav bar items
                    
                }
                .onMove { (source, destination) in
                    self.plans.move(fromOffsets: source, toOffset: destination)
                }
                .onDelete { (atOffsets) in
                    self.plans.remove(atOffsets: atOffsets)
                }
            }
            .sheet(isPresented: $isNewPlanMode) {

                TimerPlanAddView1(isPresented: self.$isNewPlanMode, plans: self.$plans)
            }
            
            TimerPlanRowSheetView(selectedPlan: self.$selectedPlan)
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle("Plans (\(plans.count)) \(isNewPlanMode ? "T" : "F")")
        .navigationBarItems(trailing:
            HStack {
                EditButton()
                
                Button (action: { self.isNewPlanMode = true }) {
                    Image(systemName: "square.and.pencil")
                    .padding(.leading)
                }
        })
        
    }
}

struct TimerPlanRowSheetView : View {
    @EnvironmentObject var model: TimerPlanModel
    @EnvironmentObject var timerHolder: TimerHolder // for timer sheet
    @Binding var selectedPlan: TimerPlan?
    
    var body: some View {
        VStack {
            EmptyView()
        }
        .sheet(item: self.$selectedPlan) { plan in
            TimerView(
                areHapticsEnabled: self.$model.areHapticsEnabled,
                speechVolume: self.$model.speechVolume,
                instruction: plan.instructions.get(at: TimerHolder.sharedInstance.count),
                dismiss: { self.selectedPlan = nil }
            )
            .environmentObject(self.timerHolder)
        }
    }
}

struct TimerPlanRowContextMenuView : View {
    
    @Binding var selectedPlan: TimerPlan?
    @Binding var plans: [TimerPlan]
    var plan: TimerPlan
    
    //@State private var isDeleteMode = false
    
    var body: some View {
        VStack {
            //if !isDeleteMode {
                Button(action: {
                    self.selectedPlan = self.plan
                }) {
                    HStack {
                        Text("Timer")
                        Image(systemName: "timer")
                    }
                }
                Button(action: {
                    let newPlan = TimerPlan(self.plan)
                    let newPlanIndex = self.plans.firstIndex { $0.id == self.plan.id }
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
          //  }
            Button(action: {
                
               // if self.isDeleteMode {
                self.plans.removeAll { $0.id == self.plan.id } // TODO: revisit to analyze if this is best practice for deleting a single item from a context menu
                /*
                let firstIndex = self.plans.firstIndex { $0.id == self.plan.id }
                    if let index = firstIndex {
                        self.plans.remove(at: index)
                    }*/
              //  }
                
              //  self.isDeleteMode.toggle()
                
            }) {
                HStack {
                    Text("Delete")
                    Image(systemName: "trash")
                }
            }
        }
    }
}

struct TimerPlanListView1_Previews: PreviewProvider {
    static var previews: some View {
        TimerPlanListView1(plans: .constant([
            TimerPlan(title: "Some Plan", stages: [
                TimerPlanStage(pourRate: 5, duration: 10),
                TimerPlanStage(pourRate: 0 , duration: 20),
            ]),
            TimerPlan(title: "Another Plan", stages: [
                TimerPlanStage(pourRate: 4, duration: 15),
                TimerPlanStage(pourRate: 0 , duration: 25),
            ])
        ]))
    }
}

/*
 for inside of the list view:
 
 HStack(alignment: .top) {
     
     TimelineView(stages: plan.stages,
                  containerWidth: 200,
                  planScale: self.getScale(of: plan)
     )
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
 
 */




