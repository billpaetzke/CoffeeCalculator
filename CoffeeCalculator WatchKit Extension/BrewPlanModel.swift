//
//  BrewPlanModel.swift
//  CoffeeCalculator WatchKit Extension
//
//  Created by Bill Paetzke on 2/28/20.
//  Copyright © 2020 Bill Paetzke. All rights reserved.
//

import Foundation

final class BrewPlanModel : ObservableObject {
    
    @Published var coffeeMass : Double = 20.0 {
        didSet {
            if (waterOverCoffeeInt != ratioInt) {
                waterMass = coffeeMass * ratio
            }
        }
    }
    
    @Published var waterMass : Double = 300.0 {
        didSet {
            if (waterOverCoffeeInt != ratioInt) {
                coffeeMass = waterMass / ratio
            }
        }
    }
    
    @Published var ratio : Double = 15.0 {
        didSet {
            if (waterOverCoffeeInt != ratioInt) {
                waterMass = coffeeMass * ratio
            }
        }
    }
    
    private var waterOverCoffeeInt : Int {
        Int((10 * waterMass / coffeeMass).rounded())
    }
    
    private var ratioInt : Int {
        Int((10 * ratio).rounded())
    }
   
}
