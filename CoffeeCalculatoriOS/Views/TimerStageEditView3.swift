//
//  TimerStageEditView3.swift
//  CoffeeCalculatoriOS
//
//  Created by Bill Paetzke on 5/6/20.
//  Copyright © 2020 Bill Paetzke. All rights reserved.
//

import SwiftUI

struct TimerStageEditView3: View {
    
    @Binding var stage: TimerPlanStage
    
    var body: some View {
        Form {
            
            Section(header: Text("\(stage.duration * stage.pourRate)g")) {
                
                Stepper("Duration: \(stage.duration)s", value: $stage.duration, in: 0...300)
                
                Stepper("Pour Rate: \(stage.pourRate)g/s", value: $stage.pourRate, in: 0...20)
            }
            
        }
        .navigationBarTitle("\(stage.duration * stage.pourRate)g")
    }
}

struct TimerStageEditView3_Previews: PreviewProvider {
    static var previews: some View {
        TimerStageEditView3(stage: .constant(TimerPlanStage(pourRate: 5, duration: 10)))
    }
}
