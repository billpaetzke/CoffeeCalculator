//
//  WatchStepper.swift
//  CoffeeCalculator WatchKit Extension
//
//  Created by Bill Paetzke on 2/13/20.
//  Copyright © 2020 Bill Paetzke. All rights reserved.
//

import SwiftUI

struct WatchStepper: View {
    
    @Binding var value : Double
    
    var body: some View {
        HStack {
            Button(action: {
                self.value = (self.value / 10.0).rounded(.up) * 10.0 - 10.0
            }) {
                Text("-").fontWeight(.bold)
            }
            VStack {
                Text(String(Int(self.value.rounded())))
                .font(.title)
                .focusable(true)
                    .digitalCrownRotation(self.$value, from: 100, through: 999, by: 1, sensitivity: .low, isContinuous: false, isHapticFeedbackEnabled: true)
            Text("grams")
            }.layoutPriority(1)
            Button(action: {
                self.value = (self.value / 10.0).rounded(.down) * 10.0
                    + 10.0
            }) {
                Text("+").fontWeight(.bold)
            }
        }
    }
}

struct WatchStepper_Previews: PreviewProvider {
    
    static var previews: some View {
      PreviewWrapper()
    }

    struct PreviewWrapper: View {
        @State private var exampleValue : Double = 29.6

        var body: some View {
            WatchStepper(value: $exampleValue)
        }
    }
}
