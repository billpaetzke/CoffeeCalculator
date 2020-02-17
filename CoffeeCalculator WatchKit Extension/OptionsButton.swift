//
//  OptionsButton.swift
//  CoffeeCalculator WatchKit Extension
//
//  Created by Bill Paetzke on 2/11/20.
//  Copyright © 2020 Bill Paetzke. All rights reserved.
//

import SwiftUI

struct OptionsButton: View {
    
    @Binding var boundValue : Double
    var from : Double
    var by : Double
    var over : Int
    
    var body: some View {
        Button(action: {
            
            let distance = Int((self.boundValue - self.from) / self.by)
            let option = (distance + 1) % self.over
            
            self.boundValue = Double(option) * self.by + self.from
        }) {
            Text("\(Int(boundValue))")
        }
    }
}

struct OptionsButton_Previews: PreviewProvider { // preview does not work TBD
    
    @State static var someNumber : Double = 30
    
    static var previews: some View {
        OptionsButton(boundValue: Self.$someNumber, from: 30, by: 5, over: 4)
    }
}
