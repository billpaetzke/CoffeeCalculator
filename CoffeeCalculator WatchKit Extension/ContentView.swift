//
//  ContentView.swift
//  CoffeeCalculator WatchKit Extension
//
//  Created by Bill Paetzke on 1/15/20.
//  Copyright © 2020 Bill Paetzke. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    let coffeeMassMin = 50
    let coffeeMassMax = 1000
    
    @State private var selectedCoffeeMass = 250 - 50
    
    @State private var selectedWaterCoffeeRatio = 160 - 120
    
    var selectedWaterMass : Int {
        Int(Double(
            Double(selectedWaterCoffeeRatio + 120) / Double(10)
                * Double(selectedCoffeeMass + 50) / Double(10)
        ).rounded()
        )
    }
    
    @State private var textCoffeeMass = 25.0
    
    /*
     func getWaterMass() -> Int
     {
     return selectedCoffeeMass / 10 * selectedWaterCoffeeRatio
     }*/
    
    var body: some View {
        
        VStack {
            
            
            HStack {
                Picker(selection:$selectedCoffeeMass, label: Text("Coffee")) {
                    ForEach(coffeeMassMin..<coffeeMassMax) {
                        Text(String(Double($0)/Double(10)))
                        //.background(Color.blue)
                    }
                }//.background(Color.orange)
                
                Text("g")//.background(Color.blue)
                
                Picker(selection:$selectedWaterCoffeeRatio, label: Text("Ratio")) {
                    ForEach(120..<200) {
                        Text(String(Double($0)/Double(10)))
                    }
                }//.background(Color.purple)
                
                Text(":1")//.background(Color.blue)
                
            }
            
            VStack(alignment: .leading) {
                Text("Water").font(.headline)
                HStack {
                    Text(String(self.selectedWaterMass)).font(.title)//.background(Color.purple)
                    Button(action: {}) {
                        Text("g").font(.title)
                    }//.background(Color.blue)
                }
            }
            
            
        }.navigationBarTitle("Coffee Calculator")//.background(Color.red)
        
        
        /*
         Spacer()
         
         Text(String((textCoffeeMass * 10).rounded()/Double(10)))
         .focusable(true)
         .digitalCrownRotation($textCoffeeMass, from: 5, through: 50, by: 0.1, sensitivity: .high, isContinuous: false, isHapticFeedbackEnabled: true)
         */
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
