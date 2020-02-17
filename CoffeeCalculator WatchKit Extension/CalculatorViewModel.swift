//
//  CalculatorViewModel.swift
//  CoffeeCalculator WatchKit Extension
//
//  Created by Bill Paetzke on 2/11/20.
//  Copyright © 2020 Bill Paetzke. All rights reserved.
//

import Foundation

final class CalculatorViewModel : ObservableObject {
    @Published var brewMass : Double = 350
    @Published var waterCoffeeRatio : Double = 17
    var coffeeMass : Double {
        brewMass / (waterCoffeeRatio - 2.0)
    }
    var waterMass : Double {
        waterCoffeeRatio * coffeeMass
    }
}
