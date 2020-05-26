//
//  TimerPlanRowView.swift
//  CoffeeCalculatoriOS
//
//  Created by Bill Paetzke on 5/6/20.
//  Copyright © 2020 Bill Paetzke. All rights reserved.
//

import SwiftUI

struct TimerPlanRowView: View {

    @Binding var plan: TimerPlan
    
    var body: some View {
        NavigationLink(destination: TimerPlanView2(plan: $plan)
        ) {
            VStack {
                Text(plan.title).font(.headline)
                Text("\(plan.pourMass)g -> \(plan.duration / 60)m\(plan.duration % 60)s").font(.footnote)
            }
        }
    }
}

struct TimerPlanRowView_Previews: PreviewProvider {
    static var previews: some View {
        
        TimerPlanRowView(plan: .constant(TimerPlan(title: "Name of Some Plan", stages: [
            TimerPlanStage(pourRate: 5, duration: 10),
            TimerPlanStage(pourRate: 0 , duration: 20),
        ])))
            .previewLayout(.sizeThatFits)
            
    }
}
