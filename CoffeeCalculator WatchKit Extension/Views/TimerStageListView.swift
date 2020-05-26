//
//  TimerStageListView.swift
//  CoffeeCalculator WatchKit Extension
//
//  Created by Bill Paetzke on 4/18/20.
//  Copyright © 2020 Bill Paetzke. All rights reserved.
//

import SwiftUI

struct TimerStageListView: View {
    
    @EnvironmentObject var model : TimerPlanModel
    
    @Binding var planTitle : String
    @Binding var stages : [TimerPlanStage]
    
    @State private var isPlanEditSheetShown = false
    
    var body: some View {
        VStack {
            
            TimelineView(stages: stages)
                .frame(maxHeight: 40)
            
            List {
                
                Section(
                    footer:
                    HStack {
                        Button(action: { self.stages.append(
                            TimerPlanStage(
                                pourRate: 0,
                                duration: self.stages.last(where: { $0.pourRate == 0 })?.duration ?? 20))}) {
                            HStack {
                                Image(systemName: "pause")
                                Image(systemName: "plus.circle.fill")
                            }
                        }
                        Button(action: { self.stages.append(
                            TimerPlanStage(
                                pourRate: self.stages.last(where: { $0.pourRate > 0 })?.pourRate ?? 5,
                                duration: self.stages.last(where: { $0.pourRate > 0 })?.duration ?? 12)) }) {
                            HStack {
                                Image(systemName: "play")
                                Image(systemName: "plus.circle.fill")
                            }
                        }
                    }.imageScale(.large)
                ) {
                    
                    ForEach(stages) { stage in
                        NavigationLink(destination: TimerStageEditView(stage: self.$stages[self.stages.firstIndex(of: stage)!])) {
                            HStack {
                                Text("\(stage.duration)s")
                                Text("@")
                                Text("\(stage.pourRate)g/s")
                                
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
                
            }
            .contextMenu {
                Button(action: {
                    self.isPlanEditSheetShown = true
                }) {
                    VStack {
                        Image(systemName: "square.and.pencil")
                        Text("Rename Plan")
                    }
                }
            }
            .sheet(isPresented: $isPlanEditSheetShown) {
                Form {
                    TextField("Plan Title", text: self.$planTitle)
                }.navigationBarTitle("OK")
            }
            .navigationBarTitle(planTitle)
        }
    }
}

struct TimerStageEditView : View {
    
    @EnvironmentObject var model : TimerPlanModel
    
    @Binding var stage : TimerPlanStage
    
    //private let pourRates = [Int](0...20)
    //private let durations = [Int](1...300)
    
    var body : some View {
        
       // Form {
            
        VStack {
        
            HStack {
            
                Text("\(stage.duration)s")
                
                Button(action: { self.stage.duration -= 1 }) {
                    Image(systemName: "minus")
                }
                .disabled(self.stage.duration <= 1)
                
                Button(action: { self.stage.duration += 1 }) {
                    Image(systemName: "plus")
                }
                .disabled(self.stage.duration >= 300)
            }
            
            HStack {
            
                Text("\(stage.pourRate)g/s")
                
                Button(action: { self.stage.pourRate -= 1 }) {
                    Image(systemName: "minus")
                }
                .disabled(self.stage.pourRate <= 0)
                
                Button(action: { self.stage.pourRate += 1 }) {
                    Image(systemName: "plus")
                }
                .disabled(self.stage.pourRate >= 20)
            }
            
           
            
        }
       // }
    }
}

struct TimerStageListView_Previews: PreviewProvider {
    static var previews: some View {
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
