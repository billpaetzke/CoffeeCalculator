//
//  TimerPlanAddView1.swift
//  CoffeeCalculatoriOS
//
//  Created by Bill Paetzke on 5/6/20.
//  Copyright © 2020 Bill Paetzke. All rights reserved.
//

import SwiftUI

struct TimerPlanAddView1: View {

    @Binding var isPresented: Bool
    @Binding var plans: [TimerPlan]
    
    @State private var title = ""
    @State private var stages: [TimerPlanStage] = []
    @State private var newStage = TimerPlanStage(pourRate: 0, duration: 1)
    
    var body: some View {
        Form {

            TextField("Title", text: $title)
            
            Section(header:
                   // HStack {
                        Text("Stages")
                       /*if !stages.isEmpty {
                            Spacer()
                            EditButton()
                        }*/
            //    }
                ) {
                    //List {
                        ForEach(stages) { stage in
                            HStack {
                                Text("\(stage.duration)s")
                                Text("\(stage.pourRate)g/s")
                            }
                        }
                       /* .onMove { (source, destination) in
                            self.stages.move(fromOffsets: source, toOffset: destination)
                        }
                        .onDelete { (source) in
                            self.stages.remove(atOffsets: source)
                        }*/
                    //}
                }
                
                Section {
                    Stepper("Duration: \(newStage.duration)s", value: $newStage.duration, in: 0...300)
                    
                    Stepper("Pour Rate: \(newStage.pourRate)g/s", value: $newStage.pourRate, in: 0...20)
                    
                    Button(action:{
                        
                        self.stages.append(
                            TimerPlanStage(
                                pourRate: self.newStage.pourRate,
                                duration: self.newStage.duration
                        ))
                        
                    }) {
                        Image(systemName: "plus.circle")
                    }
                }
            
        }.sheetBarItems(
            leading:
            Button(action: { self.isPresented = false }) {
                Image(systemName: "xmark.circle")
                    .padding(.trailing)
            }
            , trailing:
            Button(action: {
                self.plans.append(TimerPlan(title: self.title, stages: self.stages))
                self.isPresented = false
            }) {
                Image(systemName: "plus.circle")
                    .padding(.leading)
            }
        )
        
    }
}

struct TimerPlanAddView1_Previews: PreviewProvider {
    static var previews: some View {
        TimerPlanAddView1(isPresented: .constant(true), plans: .constant([]))
    }
}
