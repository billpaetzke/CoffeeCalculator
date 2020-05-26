//
//  TimerStageEditView.swift
//  CoffeeCalculatoriOS
//
//  Created by Bill Paetzke on 5/4/20.
//  Copyright © 2020 Bill Paetzke. All rights reserved.
//

import SwiftUI

struct TimerStageEditView : View {
    
    @EnvironmentObject var model : TimerPlanModel
    
    @Binding var stage : TimerPlanStage
    
    var body : some View {
        
        Form {
            
            Section(header: Text("\(stage.duration * stage.pourRate)g")) {
                
                Stepper("Duration: \(stage.duration)s", value: $stage.duration, in: 0...300)
                
                Stepper("Pour Rate: \(stage.pourRate)g/s", value: $stage.pourRate, in: 0...20)
            }
            
        }
    .navigationBarTitle("Test")
        
    }
}

struct TimerStageEditView_Previews: PreviewProvider {
    static var previews: some View {
        TimerStageEditView(stage: .constant(TimerPlanStage(pourRate: 5, duration: 10)))
    }
}
