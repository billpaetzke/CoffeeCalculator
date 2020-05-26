//
//  ContentView.swift
//  CoffeeCalculatoriOS
//
//  Created by Bill Paetzke on 4/1/20.
//  Copyright © 2020 Bill Paetzke. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    var brewPlanModel : BrewPlanModel
    var timerHolder : TimerHolder
    @ObservedObject var timerPlanModel : TimerPlanModel
    
    @State private var showCaffeineSheet = false
    
    var body: some View {
        
        NavigationView {
            TimerPlanListView1(plans: self.$timerPlanModel.plans)
                .environmentObject(timerPlanModel)
                .environmentObject(timerHolder)
        }
        
        
        
        /*   NavigationView {
         VStack {
         NavigationLink(destination:
         CalculatorView().environmentObject(brewPlanModel)
         ) {
         Text("Calculator")
         }
         
         NavigationLink(destination:
         */
        
        /* most recent: 5/6
        NavigationView {
            
            TimerPlanListView(
                plans: $timerPlanModel.plans
            )
            .environmentObject(timerPlanModel)
            .environmentObject(brewPlanModel)
            .environmentObject(TimerHolder.sharedInstance)
        }*/
        
        /*   ) {
         Text("Timer")
         }
         .padding()
         
         Button(action: { self.showCaffeineSheet = true }) {
         Text("Caffeine Logger")
         }
         }
         .sheet(isPresented: $showCaffeineSheet) {
         CaffeineView(isPresented: self.$showCaffeineSheet)
         .navigationBarTitle("X")
         }
         }*/
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            brewPlanModel: BrewPlanModel(),
            timerHolder: TimerHolder.sharedInstance,
            timerPlanModel: TimerPlanModel(plans: [
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
        ).environment(\.colorScheme, .dark)
    }
}
