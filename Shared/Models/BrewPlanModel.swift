//
//  BrewPlanModel.swift
//  CoffeeCalculator WatchKit Extension
//
//  Created by Bill Paetzke on 2/28/20.
//  Copyright © 2020 Bill Paetzke. All rights reserved.
//

import Foundation

enum BrewMetric {
    case none
    case coffee
    case water
    case ratio
}

final class BrewPlanModel : ObservableObject {
    
    @Published var lockState : BrewMetric = .ratio
    
    @Published var coffeeMass : Double = 20.0 {
        didSet {
            if (waterOverCoffeeInt != ratioInt) {
                
                switch lockState {
                case .ratio:
                    waterMass = coffeeMass * ratio
                default:
                    ratio = waterMass / coffeeMass
                }
                
            }
        }
    }
    
    @Published var waterMass : Double = 300.0 {
        didSet {
            if (waterOverCoffeeInt != ratioInt) {
                
                switch lockState {
                case .ratio:
                    coffeeMass = waterMass / ratio
                default:
                    ratio = waterMass / coffeeMass
                }
                
            }
        }
    }
    
    @Published var ratio : Double = 15.0 {
        didSet {
            if (waterOverCoffeeInt != ratioInt) {
                
                switch lockState {
                case .water:
                    coffeeMass = waterMass / ratio
                default:
                    waterMass = coffeeMass * ratio
                }
                
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
