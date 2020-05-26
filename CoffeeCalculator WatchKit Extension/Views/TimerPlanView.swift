//
//  TimerPlanView.swift
//  CoffeeCalculator WatchKit Extension
//
//  Created by Bill Paetzke on 2/28/20.
//  Copyright © 2020 Bill Paetzke. All rights reserved.
//

import SwiftUI

struct TimerPlanView: View {
    
    @EnvironmentObject var brewPlanModel : BrewPlanModel
    
    @ObservedObject var timerHolder : TimerHolder
    
    @Binding var plans : [TimerPlan]
    @Binding var selectedPlan : TimerPlan?
    @Binding var areHapticsEnabled : Bool
    @Binding var speechVolume : Float
    
    @State private var showCaffeineSheet = false
    @State private var showCalcSheet = false
    
    var body: some View {
        
        ZStack {
            ScrollView {
                
                HStack {
                    Button (action:{self.showCalcSheet = true}) {
                        Image(systemName: "plus.slash.minus")
                    }.sheet(isPresented: $showCalcSheet) {
                        CalculatorView()
                            .navigationBarTitle("X")
                            .environmentObject(self.brewPlanModel)
                    }
                    
                    Button (action: {self.showCaffeineSheet = true}) {
                        Image(systemName: "square.and.pencil")
                    }.sheet(isPresented: $showCaffeineSheet) {
                        CaffeineView(isPresented: self.$showCaffeineSheet)
                            .navigationBarTitle("X")
                    }
                }
                
                ForEach($plans.wrappedValue) { plan in
                    Button (action: {
                        
                        self.selectedPlan = plan
                        
                        switch self.timerHolder.state {
                        case .reset:
                            self.timerHolder.start()
                        case .running:
                            self.timerHolder.stop()
                        case .stopped:
                            self.timerHolder.reset()
                        }
                        
                        self.$plans.wrappedValue.move(fromOffsets: IndexSet([self.plans.firstIndex(of: plan)!]), toOffset: 0)
                    }) {
                        
                        VStack(alignment: .leading, spacing: 0) {
                            
                            HStack(alignment: .top) {
                                
                                TimelineView(stages: plan.stages,
                                             planScale: Double(plan.duration)/Double(self.plans.max(by: { $0.duration < $1.duration })!.duration)
                                )
                                
                                Spacer()
                                
                                NavigationLink(destination:
                                    TimerStageListView(
                                        planTitle: self.$plans[self.plans.firstIndex(of: plan)!].title,
                                        stages: self.$plans[self.plans.firstIndex(of: plan)!].stages)
                                        .environmentObject(self.timerPlanModel)
                                    )
                                {
                                    Image(systemName: "ellipsis")
                                }
                                .clipShape(Circle())
                                .fixedSize()
                            }
                            
                            Text("\(plan.title)").font(.headline)
                            //Text("\(plan.pours)x @ \(plan.stages[0].pourRate)g/s").font(.subheadline)
                            Text("\(plan.pourMass)g -> \(plan.duration / 60)m\(plan.duration % 60)s").font(.footnote)
                        }
                        
                        
                    }
                }
            }
            .opacity(timerHolder.state == .reset ? 1 : 0)
            .id(timerHolder.state == .stopped) // refreshing the list takes back scroll focus
            
            TimerView(timerHolder: timerHolder,
                      selectedPlan: $selectedPlan,
                      areHapticsEnabled: $areHapticsEnabled,
                      speechVolume:  $speechVolume,
                      instruction: selectedPlan?.instructions.get(at: timerHolder.count))
                .opacity(timerHolder.state == .reset ? 0 : 1)
            
        }
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
    
    @EnvironmentObject var timerPlanModel : TimerPlanModel  // TODO check after Xcode 11.4 to see if this useless reference is no longer needed
}

struct TimerPlanView_Previews: PreviewProvider {
    static var previews: some View {
        TimerPlanView(
            timerHolder: TimerHolder.sharedInstance,
              plans: .constant([
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
                    ]),
              selectedPlan: .constant(
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
              ),
              areHapticsEnabled: .constant(true),
              speechVolume: .constant(1.0)
        ).environmentObject(BrewPlanModel())
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
