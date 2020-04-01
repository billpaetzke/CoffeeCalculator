//
//  ContentView.swift
//  CoffeeCalculator WatchKit Extension
//
//  Created by Bill Paetzke on 1/15/20.
//  Copyright © 2020 Bill Paetzke. All rights reserved.
//

import SwiftUI

struct CalculatorView: View {
    
    @ObservedObject var model : BrewPlanModel
    
    @State private var isWaterFocused = false
    @State private var isCoffeeFocused = false
    @State private var isRatioFocused = false
    
    var body: some View {
        
        VStack {
            
            Text("\(formatZero(model.waterMass))")
                .fontWeight(isWaterFocused ? .bold : .regular)
                .font(isWaterFocused ? .title : .none)
                .focusable(true, onFocusChange: {
                    isFocused in
                    self.isWaterFocused = isFocused
                })
                .digitalCrownRotation($model.waterMass, from: 120.0, through: 998.0, by: 1.0, sensitivity: .medium, isContinuous: false, isHapticFeedbackEnabled: true)
          
            Spacer()
            Text("1:\(formatOne(model.ratio))")
                .fontWeight(isRatioFocused ? .bold : .regular)
                .font(isRatioFocused ? .title : .none)
                .focusable(true, onFocusChange: {
                    isFocused in
                    self.isRatioFocused = isFocused
                })
                .digitalCrownRotation($model.ratio, from: 12.0, through: 20.0, by: 0.1, sensitivity: .low, isContinuous: false, isHapticFeedbackEnabled: true)
            Spacer()
            
            Text("\(formatOne(model.coffeeMass))")
                .fontWeight(isCoffeeFocused ? .bold : .regular)
                .font(isCoffeeFocused ? .title : .none)
                .focusable(true, onFocusChange: {
                    isFocused in
                    self.isCoffeeFocused = isFocused
                })
                .digitalCrownRotation($model.coffeeMass, from: 10.0, through: 49.9, by: 0.1, sensitivity: .low, isContinuous: false, isHapticFeedbackEnabled: true)
        }
        .navigationBarTitle("Calculator")
        
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
}

struct CalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorView(model: BrewPlanModel())
    }
}
