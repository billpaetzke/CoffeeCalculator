//
//  ContentView.swift
//  CoffeeCalculator WatchKit Extension
//
//  Created by Bill Paetzke on 1/15/20.
//  Copyright © 2020 Bill Paetzke. All rights reserved.
//

import SwiftUI

struct CalculatorView: View {
    
    @EnvironmentObject var model : BrewPlanModel
    /*
    @State private var isWaterFocused = false
    @State private var isWaterCircleFocused = false
    @State private var isCoffeeFocused = false
    @State private var isCoffeeCircleFocused = false
    @State private var isRatioFocused = false
    */
    
    @State private var selectedBrewMetric: BrewMetric = .none
    
    let scaleFactor : Double = 10
    let totalHeight : Double = 120
    
    func getRadius(area: Double) -> Double {
        (area / Double.pi).squareRoot()
    }
    
    func getDiameter(area : Double) -> Double {
        2 * getRadius(area: area)
    }
    
    func getWaterBoxHeight() -> Double {
        totalHeight * model.ratio / (model.ratio + 1)
    }
    
    func getCoffeeBoxHeight() -> Double {
        totalHeight / (model.ratio + 1)
    }
    
    func getWidth() -> Double {
        scaleFactor * (model.waterMass + model.coffeeMass) / totalHeight
    }
    
    var body: some View {
        
        
        /*
         VStack {
         RoundedRectangle(cornerRadius: 5)
         .fill(Color.blue)
         .overlay(
         RoundedRectangle(cornerRadius: 5)
         .stroke(Color.accentColor, lineWidth: isWaterCircleFocused ? 1 : 0)
         )
         .opacity(isWaterCircleFocused ? 1.0 : 0.7)
         .frame(width: CGFloat(getWidth()),
         height: CGFloat(getWaterBoxHeight()))
         .focusable(true, onFocusChange: {
         isFocused in
         self.isWaterCircleFocused = isFocused
         })
         .digitalCrownRotation($model.waterMass, from: 120.0, through: 998.0, by: 5.0, sensitivity: .high, isContinuous: false, isHapticFeedbackEnabled: true)
         
         RoundedRectangle(cornerRadius: 5)
         .fill(Color.init(UIColor.brown))
         .overlay(
         RoundedRectangle(cornerRadius: 5)
         .stroke(Color.accentColor, lineWidth: isCoffeeCircleFocused ? 1 : 0)
         )
         .opacity(isCoffeeCircleFocused ? 1.0 : 0.7)
         .frame(width: CGFloat(getWidth()),
         height: CGFloat(getCoffeeBoxHeight()))
         .focusable(true, onFocusChange: {
         isFocused in
         self.isCoffeeCircleFocused = isFocused
         })
         .digitalCrownRotation($model.coffeeMass, from: 10.0, through: 49.9, by: 0.5, sensitivity: .low, isContinuous: false, isHapticFeedbackEnabled: true)
         }
         */
        VStack(alignment: .leading, spacing: 0) {
            
            
            HStack {
                
                Image(systemName: getSymbol(uiMetric: .coffee))
                    .font(.title)
                    .frame(minWidth: 43)
                
                Text("\(formatOne(model.coffeeMass))")
                    .fontWeight(selectedBrewMetric == .coffee ? .bold : .regular)
                    .font(.title)
                    .padding(.leading, 16)
                
                    .focusable(true, onFocusChange: {
                        isFocused in
                        if isFocused {
                            self.selectedBrewMetric = .coffee
                        }
                    })
                    .digitalCrownRotation($model.coffeeMass, from: 10.0, through: 49.9, by: 0.1, sensitivity: .low, isContinuous: false, isHapticFeedbackEnabled: true)
                    .onTapGesture {
                        self.model.lockState = self.model.lockState == .water ? .ratio : .water
                }
                
                
                
                Spacer()
                
            }
            
            HStack {
                Image(systemName: getSymbol(uiMetric: .ratio))
                    .font(.title)
                    .frame(minWidth: 43)
                Text("x\(formatOne(model.ratio))")
                    .fontWeight(selectedBrewMetric == .ratio ? .bold : .regular)
                    .font(.title)
                    
                    //.offset(x: CGFloat(getWidth() / 2 + 32), y: CGFloat(getWaterBoxHeight() / 2))
                    .focusable(true, onFocusChange: {
                        isFocused in
                        //self.isRatioFocused = isFocused
                        if isFocused {
                            self.selectedBrewMetric = .ratio
                        }
                    })
                    .digitalCrownRotation($model.ratio, from: 12.0, through: 20.0, by: 0.1, sensitivity: .low, isContinuous: false, isHapticFeedbackEnabled: true)
                    
                    .onTapGesture {
                        self.model.lockState = self.model.lockState == .water ? .coffee : .water
                }
                
                Spacer()
            }
            
            HStack {
                Image(systemName: getSymbol(uiMetric: .water))
                    .font(.title)
                    .frame(minWidth: 43)
                
                Text("\(formatZero(model.waterMass))")
                    .fontWeight(selectedBrewMetric == .water ? .bold : .regular)
                    .font(.title)
                    .padding(.leading, 16)
                    .focusable(true, onFocusChange: {
                        isFocused in
                        //self.isWaterFocused = isFocused
                        if isFocused {
                            self.selectedBrewMetric = .water
                        }
                    })
                    .digitalCrownRotation($model.waterMass, from: 120.0, through: 998.0, by: 1.0, sensitivity: .medium, isContinuous: false, isHapticFeedbackEnabled: true)
                    .onTapGesture {
                        self.model.lockState = self.model.lockState == .ratio ? .coffee : .ratio
                }
                
                
                
                Spacer()
            }
            
        }.frame(maxWidth: .infinity)
            
            //.edgesIgnoringSafeArea(.bottom)
            .navigationBarTitle("Calculator")
        
    }
    
    private func getSymbol(uiMetric : BrewMetric) -> String {
        
        if uiMetric == self.selectedBrewMetric {
            return "dial"
        }
        else if uiMetric == self.model.lockState {
            return "lock"
        }
        else {
            return "lock.open"
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
}

struct CalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorView().environmentObject(BrewPlanModel())
    }
}

/*
 
 let scaleFactor : Double = 4
 
 func getRadius(area: Double) -> Double {
 (area / Double.pi).squareRoot()
 }
 
 func getDiameter(area : Double) -> Double {
 2 * getRadius(area: area)
 }
 
 ZStack {
 
 Circle()
 .fill(Color.blue)
 .opacity(isWaterCircleFocused ? 1.0 : 0.7)
 .frame(width: CGFloat(scaleFactor * getDiameter(area: model.waterMass)),
 height: CGFloat(scaleFactor * getDiameter(area: model.waterMass)))
 .focusable(true, onFocusChange: {
 isFocused in
 self.isWaterCircleFocused = isFocused
 })
 .digitalCrownRotation($model.waterMass, from: 120.0, through: 998.0, by: 10.0, sensitivity: .medium, isContinuous: false, isHapticFeedbackEnabled: true)
 
 Circle()
 .fill(Color.init(UIColor.brown))
 .overlay(
 Circle()
 .stroke(Color.black, lineWidth: isCoffeeCircleFocused ? 1 : 0)
 )
 .opacity(isCoffeeCircleFocused ? 1.0 : 0.7)
 .frame(width: CGFloat(scaleFactor * getDiameter(area: model.coffeeMass)),
 height: CGFloat(scaleFactor * getDiameter(area: model.coffeeMass)))
 .focusable(true, onFocusChange: {
 isFocused in
 self.isCoffeeCircleFocused = isFocused
 })
 .digitalCrownRotation($model.coffeeMass, from: 10.0, through: 49.9, by: 1.0, sensitivity: .low, isContinuous: false, isHapticFeedbackEnabled: true)
 }
 */



/*
 
 VStack {
 
 Text("\(formatZero(model.waterMass))")
 .fontWeight(isWaterFocused ? .bold : .regular)
 .font(isWaterFocused ? .title : .none)
 .focusable(true, onFocusChange: {
 isFocused in
 self.isWaterFocused = isFocused
 })
 .digitalCrownRotation($model.waterMass, from: 120.0, through: 998.0, by: 1.0, sensitivity: .medium, isContinuous: false, isHapticFeedbackEnabled: true)
 
 Text("1:\(formatOne(model.ratio))")
 .fontWeight(isRatioFocused ? .bold : .regular)
 .font(isRatioFocused ? .title : .none)
 .focusable(true, onFocusChange: {
 isFocused in
 self.isRatioFocused = isFocused
 })
 .digitalCrownRotation($model.ratio, from: 12.0, through: 20.0, by: 0.1, sensitivity: .low, isContinuous: false, isHapticFeedbackEnabled: true)
 }
 
 Text("\(formatOne(model.coffeeMass))")
 .fontWeight(isCoffeeFocused ? .bold : .regular)
 .font(isCoffeeFocused ? .title : .none)
 .focusable(true, onFocusChange: {
 isFocused in
 self.isCoffeeFocused = isFocused
 })
 .digitalCrownRotation($model.coffeeMass, from: 10.0, through: 49.9, by: 0.1, sensitivity: .low, isContinuous: false, isHapticFeedbackEnabled: true)
 }
 */
