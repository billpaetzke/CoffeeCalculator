//
//  TimerPlanAddView.swift
//  CoffeeCalculatoriOS
//
//  Created by Bill Paetzke on 5/4/20.
//  Copyright © 2020 Bill Paetzke. All rights reserved.
//

import SwiftUI

struct TimerPlanAddView: View {
    
    @EnvironmentObject var model: TimerPlanModel
    @Binding var isPresented: Bool
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
        }
        .navigationBarItems(
            leading: Button(action:{
                self.isPresented = false
            }) {Image(systemName: "xmark.circle")},
            trailing: Button(action:{
                self.model.plans.append(TimerPlan(title: self.title, stages: self.stages))
                self.isPresented = false
            }) {
                Image(systemName: "plus.circle.fill")
        })
    }
}

struct TimerPlanAddView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TimerPlanAddView(isPresented: .constant(true))
        }
    }
}
