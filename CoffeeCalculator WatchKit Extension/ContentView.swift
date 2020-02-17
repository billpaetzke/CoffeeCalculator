//
//  ContentView.swift
//  CoffeeCalculator WatchKit Extension
//
//  Created by Bill Paetzke on 1/15/20.
//  Copyright © 2020 Bill Paetzke. All rights reserved.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    var timerHolder : TimerHolder
    var extendedSessionHolder : ExtendedSessionHolder
    
    var body: some View {
       
        CalculatorView(timerHolder: timerHolder,
                       extendedSessionHolder: extendedSessionHolder,
                       calculatorViewModel: CalculatorViewModel())
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(timerHolder: TimerHolder(),
        extendedSessionHolder: ExtendedSessionHolder())
    }
}

