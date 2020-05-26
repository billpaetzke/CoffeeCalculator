//
//  CaffeineView.swift
//  CoffeeCalculatoriOS
//
//  Created by Bill Paetzke on 4/2/20.
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
        
        
        
        NavigationView {
            
            
            Form {
                if HKHealthStore.isHealthDataAvailable() {
                    // Add code to use HealthKit here.
                    
                    HStack {
                    
                        
                        
                    VStack {
                        
                        
                        
                        Stepper(value: $beverageMass, in: 120...355, step: 1) {
                            Text("\(beverageMass, specifier: "%.0f") grams")
                                .font(.title)
                        }
                        Slider(value: $beverageMass, in: 120...355)
                        
                        Text("\(Int(caffeineMass * 1000)) mg")
                    }.padding()
                    
                    CoffeeCupView(beverageMass: $beverageMass, cupMassCapacity: 355.0)
                        
                    }
                }
                else {
                    Text("Health app unavailable on your device.")
                }
            }
            .navigationBarItems(
                leading:
                Button(action: {
                    self.isPresented = false
                }) {
                    Image(systemName: "xmark.circle").imageScale(.large)
                },
                trailing:
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
                    Image(systemName: isLogging ? "checkmark" : "plus.circle.fill").imageScale(.large)
                }.disabled(isLogging)
            )
        }
        
    }
}

struct CoffeeCupView : View {
    
    @Binding var beverageMass : Double
    var cupMassCapacity : Double
    
    var body: some View {
        
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.secondary)
            .frame(width: 100, height: 150)
            .overlay(RoundedRectangle(cornerRadius: 10)
                .fill(Color.init(UIColor.brown))
                .frame(width: 80, height: CGFloat(beverageMass / cupMassCapacity) * (150 - 10))
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
