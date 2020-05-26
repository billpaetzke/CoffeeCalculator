//
//  CalculatorView.swift
//  CoffeeCalculatoriOS
//
//  Created by Bill Paetzke on 4/1/20.
//  Copyright © 2020 Bill Paetzke. All rights reserved.
//

import SwiftUI

struct CalculatorView: View {
    
    @EnvironmentObject var model : BrewPlanModel
    
    var body: some View {
        
        VStack {
        
            
            VStack {
                Stepper(value: $model.waterMass, in: 120...998, step: 1) {
                    Text("\(model.waterMass, specifier: "%.0f") grams")
                        .font(.title)
                }
                Slider(value: $model.waterMass, in: 120...998)
            }.padding()
            
            VStack {
                Stepper(value: $model.ratio, in: 12...20, step: 0.1) {
                    Text("1:\(model.ratio, specifier: "%.1f")")
                        .font(.title)
                }
                Slider(value: $model.ratio, in: 12...20)
            }.padding()
            
            VStack {
            Stepper(value: $model.coffeeMass, in: 10...49.9, step: 0.1) {
                Text("\(model.coffeeMass, specifier: "%.1f") grams")
                    .font(.title)
                }
                Slider(value: $model.coffeeMass, in: 10...49.9)
            }.padding()
            
        }
    }
}

struct CalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorView().environmentObject(BrewPlanModel())
    }
}
