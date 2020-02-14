//
//  ContentView.swift
//  CoffeeCalculator WatchKit Extension
//
//  Created by Bill Paetzke on 1/15/20.
//  Copyright © 2020 Bill Paetzke. All rights reserved.
//

import SwiftUI

struct CalculatorView: View {
    @EnvironmentObject var timerHolder: BrewTimerHolder
    
    
    let coffeeMassMin = 5.0
    let coffeeMassMax = 100.0
    
    private var coffeeMass : Double {
        brewWaterMass / (waterCoffeeRatio - 2.0)
    }
    
    @State private var waterCoffeeRatio = 18.0
    
    @State private var brewWaterMass = 352.0 /*{
        didSet {
            coffeeMass = brewWaterMass / (waterCoffeeRatio - 2.0)
        }
    }*/
    
    var waterMass : Int {
        Int((waterCoffeeRatio * coffeeMass).rounded())
    }
    
    @State private var coffeeMassFocus = true
    @State private var waterCoffeeRatioFocus = false
    
    var body: some View {
        
        VStack {
            /*
            if (self.coffeeMassFocus || self.waterCoffeeRatioFocus)
            {
                HStack {
                    
                    Button(action: {
                        if (self.coffeeMassFocus) {
                            self.coffeeMass = self.coffeeMass.rounded(.up) - 1.0
                        }
                        else if (self.waterCoffeeRatioFocus) {
                            if (self.waterCoffeeRatio > 12) {
                                self.waterCoffeeRatio = self.waterCoffeeRatio.rounded(.up) - 1.0
                            }
                        }
                    }) {
                        Image(systemName: "minus.circle.fill")
                    }
                    
                    if (self.coffeeMassFocus) {
                        Text(String(((coffeeMass * 10).rounded() / 10)))
                            .fontWeight(self.coffeeMassFocus ? .bold : .regular)
                            .layoutPriority(1)
                            .font(self.coffeeMassFocus ? .title : .body)
                            .focusable(true) {isFocused in
                                self.coffeeMassFocus = isFocused
                        }
                        .digitalCrownRotation($coffeeMass, from: coffeeMassMin, through: coffeeMassMax, by: 0.1, sensitivity: .low, isContinuous: false, isHapticFeedbackEnabled: true)
                    }
                    else if (self.waterCoffeeRatioFocus) {
                        Text(String((waterCoffeeRatio * 10).rounded() / 10))
                            .fontWeight(self.waterCoffeeRatioFocus ? .bold : .regular)
                            .layoutPriority(1)
                            .font(self.waterCoffeeRatioFocus ? .title : .body)
                            .focusable(true) {isFocused in
                                self.waterCoffeeRatioFocus = isFocused
                        }
                        .digitalCrownRotation($waterCoffeeRatio, from: 12, through: 20, by: 0.1, sensitivity: .low, isContinuous: false, isHapticFeedbackEnabled: true)
                    }
                    
                    
                    Button(action: {
                        if (self.coffeeMassFocus) {
                            self.coffeeMass = self.coffeeMass.rounded(.down) + 1.0
                        }
                        else if (self.waterCoffeeRatioFocus) {
                            if (self.waterCoffeeRatio < 20) {
                                self.waterCoffeeRatio = self.waterCoffeeRatio.rounded(.down) + 1.0
                            }
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                    }
                    
                }
            }*/
            
            
            /* cool pour over
            HStack {
                
                /*
                Button(action: {
                    self.waterCoffeeRatioFocus = true
                    self.coffeeMassFocus = false
                }) {
                    Text(String((waterCoffeeRatio * 10).rounded() / 10)).font(.footnote)
                }
                */
                VStack {
                    
                    Path { path in
                        let width = 50.0
                        let height = width * 0.75
                        let spacing = width * 0.030
                        let middle = width / 2
                        let topWidth = 0.226 * width
                        let topHeight = 0.488 * height
                        
                        path.addLines([
                            CGPoint(x: middle, y: spacing),
                            CGPoint(x: middle - topWidth, y: topHeight - spacing),
                            CGPoint(x: middle, y: topHeight / 2 + spacing),
                            CGPoint(x: middle + topWidth, y: topHeight - spacing),
                            CGPoint(x: middle, y: spacing)
                        ])
                        
                        path.move(to: CGPoint(x: middle, y: topHeight / 2 + spacing * 3))
                        
                        path.addLines([
                            CGPoint(x: middle - topWidth, y: topHeight + spacing),
                            CGPoint(x: spacing, y: height - spacing),
                            CGPoint(x: width - spacing, y: height - spacing),
                            CGPoint(x: middle + topWidth, y: topHeight + spacing),
                            CGPoint(x: middle, y: topHeight / 2 + spacing * 3)
                        ])
                        
                        
                    }.rotationEffect(Angle(degrees: 180.0))
                        .frame(width: 50.0, height: 50 * 0.75)
                        .padding(.bottom, -10)
                        
                    ZStack(alignment: .center) {
                    RoundedRectangle(cornerRadius: 50 * 0.1)
                        .size(width: 50.0 * 0.6, height: 50 * 1.1)
                        .frame(width: 50.0 * 0.6, height: 50 * 1.1)
                        
                        RoundedRectangle(cornerRadius: 50 * 0.1 * 0.9)
                        .size(width: 50.0 * 0.6 * 0.8, height: 50 * 1.1 * 0.9)
                        .frame(width: 50.0 * 0.6 * 0.8, height: 50 * 1.1 * 0.9)
                        .foregroundColor(Color.blue)
                        
                    }
                        
                }
                
                VStack {
                    
                    //Button(action: {}) {
                        Text(String(waterMass)).font(.footnote)
                    //}
                    Divider()
                    /*Button(action: {
                        self.coffeeMassFocus = true
                        self.waterCoffeeRatioFocus = false
                    }) {*/
                    HStack {
                        Button(action: {
                        self.coffeeMass = self.coffeeMass.rounded(.up) - 1.0
                        }) {
                        Text("-").fontWeight(.bold)
                        }
                        Text(String(((coffeeMass * 10).rounded() / 10))).font(.footnote)
                            .focusable(true)
                    .digitalCrownRotation(self.$coffeeMass, from: coffeeMassMin, through: coffeeMassMax, by: 0.1, sensitivity: .low, isContinuous: false, isHapticFeedbackEnabled: true)
                    Button(action: {
                        self.coffeeMass = self.coffeeMass.rounded(.down) + 1.0
                    }) {
                        Text("+").fontWeight(.bold)
                    }
                    }
                    
                    //}
                    Divider()
                    //Button(action: {}) {
                    HStack {
                    Button(action: {
                        self.brewWaterMass = self.brewWaterMass.rounded(.up) - 5.0
                    }) {
                    Text("-").fontWeight(.bold)
                    }
                        Text(String(Int(brewWaterMass.rounded())))
                        .font(.footnote)
                    .frame(height: 30 * 1.1 * 0.9)
                        .focusable(true)
                        .digitalCrownRotation(self.$brewWaterMass, from: 100, through: 999, by: 1, sensitivity: .low, isContinuous: false, isHapticFeedbackEnabled: true)
                    Button(action: {
                        self.brewWaterMass = self.brewWaterMass.rounded(.down) + 5.0
                    }) {
                        Text("+").fontWeight(.bold)
                    }
                    
                    }
                   // }
                    
                }
            } cool pour over */
            
            /*
             HStack {
             if (self.coffeeMassFocus) {
             Button(action: {
             self.coffeeMass = self.coffeeMass.rounded(.up) - 1.0
             }) {
             Text("-").fontWeight(.bold)
             }
             }
             
             Text(String(((coffeeMass * 10).rounded() / 10)))
             .fontWeight(self.coffeeMassFocus ? .bold : .regular)
             .layoutPriority(1)
             .font(self.coffeeMassFocus ? .title : .body)
             .focusable(true) {isFocused in
             self.coffeeMassFocus = isFocused
             }
             .digitalCrownRotation($coffeeMass, from: coffeeMassMin, through: coffeeMassMax, by: 0.1, sensitivity: .low, isContinuous: false, isHapticFeedbackEnabled: true)
             
             if (self.coffeeMassFocus) {
             Button(action: {
             self.coffeeMass = self.coffeeMass.rounded(.down) + 1.0
             }) {
             Text("+").fontWeight(.bold)
             }
             }
             }
             
             HStack {
             if (self.waterCoffeeRatioFocus) {
             Button(action: {
             if (self.waterCoffeeRatio > 12) {
             self.waterCoffeeRatio = self.waterCoffeeRatio.rounded(.up) - 1.0
             }
             }) {
             Text("-").fontWeight(.bold)
             }
             }
             Text(String((waterCoffeeRatio * 10).rounded() / 10))
             .fontWeight(self.waterCoffeeRatioFocus ? .bold : .regular)
             .layoutPriority(1)
             .font(self.waterCoffeeRatioFocus ? .title : .body)
             .focusable(true) {isFocused in
             self.waterCoffeeRatioFocus = isFocused
             }
             .digitalCrownRotation($waterCoffeeRatio, from: 12, through: 20, by: 0.1, sensitivity: .low, isContinuous: false, isHapticFeedbackEnabled: true)
             if (self.waterCoffeeRatioFocus) {
             Button(action: {
             if (self.waterCoffeeRatio < 20) {
             self.waterCoffeeRatio = self.waterCoffeeRatio.rounded(.down) + 1.0
             }
             }) {
             Text("+").fontWeight(.bold)
             }
             }
             }
             
             
             
             Text(String(waterMass))
             
             */
            
            /*    .focusable(true)
             .digitalCrownRotation($coffeeMass, from: coffeeMassMin, through: coffeeMassMax, by: 0.1, sensitivity: .low, isContinuous: false, isHapticFeedbackEnabled: true)*/
            /*
            NavigationLink(destination: BrewTimerView().environmentObject(timerHolder)) {
                Image(systemName: "stopwatch")
            }*/
            
            /* small glass
            ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: 75 * 0.1)
                .size(width: 75.0 * 0.6, height: 75.0 * 0.6)
                .frame(width: 75.0 * 0.6, height: 75.0 * 0.6)
                
                RoundedRectangle(cornerRadius: 75.0 * 0.1 * 0.9)
                .size(width: 75.0 * 0.6 * 0.8, height: 75.0 * 0.6 * 0.9)
                .frame(width: 75.0 * 0.6 * 0.8, height: 75.0 * 0.6 * 0.9)
                    .foregroundColor(Color.blue)
                
            }
            end small glass */
            
            HStack {
                Button(action: {
                    self.brewWaterMass = (self.brewWaterMass / 10.0).rounded(.up) * 10.0 - 10.0
                }) {
                    Text("-").fontWeight(.bold)
                }
                VStack {
                Text(String(Int(brewWaterMass.rounded())))
                    .font(.title)
                    .focusable(true)
                    .digitalCrownRotation($brewWaterMass, from: 100, through: 999, by: 1, sensitivity: .low, isContinuous: false, isHapticFeedbackEnabled: true)
                Text("grams")
                }.layoutPriority(1)
                Button(action: {
                    self.brewWaterMass = (self.brewWaterMass / 10.0).rounded(.down) * 10.0
                        + 10.0
                }) {
                    Text("+").fontWeight(.bold)
                }
            }
            
            HStack {
                
                Button(action: {
                    self.waterCoffeeRatio = Double(((Int(self.waterCoffeeRatio) - 15 + 1) % 4) + 15)
                }) {
                    Text(String(Int(waterCoffeeRatio)) + "x")
                }
                
                VStack {
                    Text(String(waterMass))
                    //Text(String(((2 * coffeeMass * 10).rounded() / 10)))
                    Text(String(((coffeeMass * 10).rounded() / 10)))
                    //Text(String((waterCoffeeRatio * 10).rounded() / 10))
                }
                
                NavigationLink(destination: BrewTimerView(beverageMass: $brewWaterMass, waterCoffeeRatio: $waterCoffeeRatio).environmentObject(timerHolder)) {
                    Image(systemName: "stopwatch")
                }
                
                
            }
            
            
            
        }.navigationBarTitle("Consistent Coffee")//.background(Color.red)
        
        
        /*
         Spacer()
         
         Text(String((textCoffeeMass * 10).rounded()/Double(10)))
         .focusable(true)
         .digitalCrownRotation($textCoffeeMass, from: 5, through: 50, by: 0.1, sensitivity: .high, isContinuous: false, isHapticFeedbackEnabled: true)
         */
        
        
    }
}

struct CalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorView().environmentObject(BrewTimerHolder())
    }
}
