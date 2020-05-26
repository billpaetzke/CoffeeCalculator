//
//  TimerStageListView.swift
//  CoffeeCalculatoriOS
//
//  Created by Bill Paetzke on 4/23/20.
//  Copyright © 2020 Bill Paetzke. All rights reserved.
//

import SwiftUI

struct TimerStageListView: View {
    @Environment(\.editMode) var mode
    
    @EnvironmentObject var model : TimerPlanModel
    
    @Binding var planTitle : String
    @Binding var stages : [TimerPlanStage]
    
    @State private var isPlanEditSheetShown = false
    
    var body: some View {
        VStack {
            /*
            if self.mode?.wrappedValue == .active {
                TextField("Title", text: $planTitle)
            }
            
            TimelineView(stages: stages, containerWidth: 200)
                .frame(maxHeight: 20)*/
            
            List {
                
                Section {
                    ForEach(stages) { stage in
                        NavigationLink(destination: TimerStageEditView(stage: self.getBindable(stage))) {
                            HStack {
                                Text("\(stage.duration)s")
                                Text("@")
                                Text("\(stage.pourRate)g/s")
                                Spacer()
                                Text("\(stage.duration * stage.pourRate)g")
                            }
                        }.environmentObject(self.model)
                    }
                    .onMove { (source, destination) in
                        self.stages.move(fromOffsets: source, toOffset: destination)
                    }
                    .onDelete { (source) in
                        self.stages.remove(atOffsets: source)
                    }
                    
                }
                
                Section/*(header: Text("Add Pour"))*/ {
                    Button(action: { self.stages.append(
                        TimerPlanStage(
                            pourRate: self.stages.last(where: { $0.pourRate > 0 })?.pourRate ?? 5,
                            duration: self.stages.last(where: { $0.pourRate > 0 })?.duration ?? 12))
                    }) {
                        HStack {
                            Image(systemName: "play")
                            Image(systemName: "plus.circle.fill")
                        }
                    }
                    Button(action: { self.stages.append(
                        TimerPlanStage(
                            pourRate: 0,
                            duration: self.stages.last(where: { $0.pourRate == 0 })?.duration ?? 20))}) {
                                HStack {
                                    Image(systemName: "pause")
                                    Image(systemName: "plus.circle.fill")
                                }
                    }
                }
            }.listStyle(GroupedListStyle())
        }
        
    }
    
    private func getBindable(_ stage: TimerPlanStage) -> Binding<TimerPlanStage> {
        let index = self.stages.firstIndex(of: stage)
        if let foundIndex = index {
            return self.$stages[foundIndex]
        }
        else {
            return Binding.constant(TimerPlanStage(pourRate: 0, duration: 1))
        }
    }
}

struct TimerStageListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TimerStageListView(
                planTitle: .constant("Dre"),
                stages: .constant([
                    TimerPlanStage(pourRate: 5, duration: 10),
                    TimerPlanStage(pourRate: 0, duration: 30),
                    TimerPlanStage(pourRate: 5, duration: 20),
                    TimerPlanStage(pourRate: 0, duration: 25)
                ])).environmentObject(TimerPlanModel(plans: []))
        }
    }
}
