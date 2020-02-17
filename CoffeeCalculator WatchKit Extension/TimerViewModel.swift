//
//  TimerViewModel.swift
//  CoffeeCalculator WatchKit Extension
//
//  Created by Bill Paetzke on 2/11/20.
//  Copyright © 2020 Bill Paetzke. All rights reserved.
//

import Foundation

final class TimerViewModel : ObservableObject {
    @Published var pourRate : Double = 5.0
    @Published var bloomDurationSec : TimeInterval = 30.0
    @Published var spokenIntervalSec : TimeInterval = 3.0
    
    var massModel : CalculatorViewModel
    
    init(massModel : CalculatorViewModel) {
        self.massModel = massModel
    }
    
    var firstPourAmount: Double {
        (massModel.coffeeMass * 2.0 / pourRate).rounded(.up) * pourRate
    }
    
    var firstPourAmountInt: Int {
        Int(firstPourAmount.rounded())
    }
    
    var firstPourDurationSec: Int {
        Int((firstPourAmount / pourRate).rounded())
    }
    
    var finalPourAmount: Int {
        Int(massModel.waterMass.rounded())
    }
    
    var finalPourDurationSec: Int {
        Int(((massModel.waterMass - firstPourAmount) / pourRate).rounded())
    }
    
    var totalDurationSec: Int {
        firstPourDurationSec + Int(bloomDurationSec.rounded()) + finalPourDurationSec
    }
    
    func getStageNum(durationSec:Int) -> Int {
        if (durationSec < 0) {
            return 0
        }
        
        if (durationSec < firstPourDurationSec) {
            return 1
        }
        
        if (durationSec < firstPourDurationSec + Int(bloomDurationSec.rounded())) {
            return 2
        }
            
        if (durationSec < totalDurationSec) {
            return 3
        }
        
        return 4
    }
    
    func getStageMassMin(stageNum: Int) -> Double {
        switch stageNum {
            case 0:
                return 0
            case 1:
                return 0
            case 2:
                return firstPourAmount
            case 3:
                return firstPourAmount
            default:
                return massModel.waterMass
        }
    }
    
    func getStageMassMax(stageNum: Int) -> Double {
        switch stageNum {
            case 0:
                return 0
            case 1:
                return firstPourAmount
            case 2:
                return firstPourAmount
            default:
                return massModel.waterMass
        }
    }
    
    func getStageDurationSec(stageNum: Int) -> Double {
        switch stageNum {
            case 0:
                return 0
            case 1:
                return Double(firstPourDurationSec).rounded()
            case 2:
                return bloomDurationSec
            default:
                return Double(finalPourDurationSec).rounded()
        }
    }
    
    func getExpectedBrewMass(durationSec:Int) -> Double {
        
        let stageNum = getStageNum(durationSec: durationSec)
        
        switch stageNum {
        case 0:
            return 0.0
        case 1:
            return (Double(durationSec) * pourRate).rounded()
        case 2:
            return (Double(firstPourDurationSec) * pourRate).rounded()
        case 3:
            return (Double(durationSec - Int(bloomDurationSec.rounded())) * pourRate).rounded()
        default:
            return massModel.waterMass
        }
    }
}
