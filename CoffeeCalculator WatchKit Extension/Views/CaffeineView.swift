//
//  CaffeineView.swift
//  CoffeeCalculator WatchKit Extension
//
//  Created by Bill Paetzke on 2/24/20.
//  Copyright © 2020 Bill Paetzke. All rights reserved.
//

import SwiftUI
import HealthKit

struct CaffeineView: View {
    
    @State private var beverageMass = 236.0
    let caffeineRatio = 0.095 / 236.59
    @State private var isLogging = false
    @Binding var isPresented : Bool
    let cupMassCapacity = 354.0
    
    private var caffeineMass : Double {
        beverageMass * caffeineRatio
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
    
    var body: some View {
        
        VStack {
            if HKHealthStore.isHealthDataAvailable() {
                // Add code to use HealthKit here.
                
                HStack {
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("\(formatZero(beverageMass))")
                            .fontWeight(.bold)
                            .font(.title)
                            .focusable(true)
                            .digitalCrownRotation($beverageMass, from: 120.0, through: cupMassCapacity, by: 4.0, sensitivity: .high, isContinuous: false, isHapticFeedbackEnabled: true)
                        Text("grams").font(.subheadline)
                        /*
                        Spacer()
                        Text("\(Int(caffeineMass * 1000))")
                        Text("mg")
                            .font(.subheadline)*/
                    }
                    
                    CoffeeCupView(beverageMass: $beverageMass, cupMassCapacity: cupMassCapacity)
                        .padding(.trailing)
                    
                   
                    
                   
                    
                    
                    
                    
                    
                    
                }
                
                Button(action: {
                    self.isLogging = true
                    
                    let healthStore = HKHealthStore()
                    
                    let allTypes = Set([HKObjectType.quantityType(forIdentifier: .dietaryCaffeine)!])
                    
                    healthStore.requestAuthorization(toShare: allTypes, read: allTypes) { (success, error) in
                        if success {
                            healthStore.save(HKQuantitySample(type: HKObjectType.quantityType(forIdentifier: .dietaryCaffeine)!, quantity: HKQuantity(unit: .gram(), doubleValue: self.caffeineMass), start: Date(), end: Date()), withCompletion: { (success, error) in
                                
                                if success {
                                    self.isPresented = false
                                }
                                else {
                                    print(error?.localizedDescription ?? "nada")
                                    
                                    self.isLogging = false
                                }
                            })
                        }
                        else {
                            
                            print(error?.localizedDescription ?? "nada")
                            
                            self.isLogging = false
                        }
                    }
                }) {
                    HStack {
                        Text("\(Int( (caffeineMass * 1000.0).rounded() )) mg")
                            .padding()
                        Spacer()
                        Image(systemName: isLogging ? "checkmark" : "plus")
                            .imageScale(.large)
                            .font(Font.body.weight(.bold)).padding()
                    }
                }.disabled(isLogging)
                
            }
            else {
                Text("Health app unavailable on your device.")
            }
        }
        
    }
}

struct CoffeeCupView : View {
    
    @Binding var beverageMass : Double
    var cupMassCapacity : Double
    
    var body: some View {
        
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.secondary)
            .frame(width: 60, height: 90)
            .overlay(RoundedRectangle(cornerRadius: 10)
                .fill(Color.init(UIColor.brown))
                .frame(width: 48, height: CGFloat(beverageMass / cupMassCapacity) * (90 - 10))
                .offset(y: -5)
                ,alignment: .bottom
        )
        
    }
    
    
}

struct CaffeineView_Previews: PreviewProvider {
    static var previews: some View {
        CaffeineView(isPresented: .constant(true))
    }
}
