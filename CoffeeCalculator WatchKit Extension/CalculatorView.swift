//
//  ContentView.swift
//  CoffeeCalculator WatchKit Extension
//
//  Created by Bill Paetzke on 1/15/20.
//  Copyright © 2020 Bill Paetzke. All rights reserved.
//

import SwiftUI

struct CalculatorView: View {
    
    var timerHolder : TimerHolder
    var extendedSessionHolder : ExtendedSessionHolder
    @ObservedObject var calculatorViewModel : CalculatorViewModel
    
    var body: some View {
        
        VStack {
            
            WatchStepper(value: self.$calculatorViewModel.brewMass)
            
            HStack {
                OptionsButton(boundValue: self.$calculatorViewModel.waterCoffeeRatio, from: 15, by: 1, over: 5)
                VStack {
                    Text("\(Int(calculatorViewModel.waterMass.rounded()))")
                    Text(String((calculatorViewModel.coffeeMass * 10).rounded() / 10))
                }
                
                NavigationLink(destination:
                    TimerView(timerHolder: timerHolder,
                              extendedSessionHolder: extendedSessionHolder,
                              timerViewModel: TimerViewModel(massModel: calculatorViewModel))) {
                                Image(systemName: "stopwatch")
                }
            }
            
            
            
        }
        
    }
}

struct CalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorView(timerHolder: TimerHolder(),
                       extendedSessionHolder: ExtendedSessionHolder(),
                       calculatorViewModel: CalculatorViewModel())
    }
}
