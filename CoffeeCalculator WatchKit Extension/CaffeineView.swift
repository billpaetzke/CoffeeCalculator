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
    
    @State private var beverageMass = 237.0
    let caffeineRatio = 0.095 / 237.0
    @State private var isLogging = false
    @Binding var isPresented : Bool
    
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
                
                Text("\(formatZero(beverageMass))")
                    .fontWeight(.bold)
                    .font(.title)
                    .focusable(true)
                    .digitalCrownRotation($beverageMass, from: 120.0, through: 998.0, by: 1.0, sensitivity: .medium, isContinuous: false, isHapticFeedbackEnabled: true)
                Text("g")
                    .font(.subheadline)
                Spacer()
                Text("\(Int(caffeineMass * 1000))")
                Text("mg")
                    .font(.subheadline)
                
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
                    Image(systemName: isLogging ? "checkmark" : "square.and.pencil")
                }.disabled(isLogging)
                
            }
            else {
                Text("Health app unavailable on your device.")
            }
        }
        
    }
}

struct CaffeineView_Previews: PreviewProvider {
    static var previews: some View {
        CaffeineView(isPresented: .constant(true))
    }
}
