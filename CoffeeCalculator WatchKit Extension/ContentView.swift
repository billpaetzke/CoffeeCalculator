//
//  ContentView.swift
//  CoffeeCalculator WatchKit Extension
//
//  Created by Bill Paetzke on 1/15/20.
//  Copyright © 2020 Bill Paetzke. All rights reserved.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    var timerHolder : TimerHolder
    var extendedSessionHolder : ExtendedSessionHolder
    @State private var showCaffeineSheet = false
    
    var body: some View {
        
        VStack {
            NavigationLink(destination:
                CalculatorView(model: BrewPlanModel())
            ) {
                Text("Calculator")
            }
            
            NavigationLink(destination:
                TimerPlanView(timerHolder: timerHolder,
                               extendedSessionHolder: extendedSessionHolder)
            ) {
                Text("Timer")
            }
            
            Button(action: { self.showCaffeineSheet = true }) {
                Text("Caffeine Logger")
            }
        }.sheet(isPresented: $showCaffeineSheet) {
            CaffeineView(isPresented: self.$showCaffeineSheet)
                .navigationBarTitle("X")
        }
        
    }
}
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            
            ContentView(timerHolder: TimerHolder.sharedInstance,
                        extendedSessionHolder: ExtendedSessionHolder())
        }
}


/*

 import UserNotifications
 @State private var howMany : Double = 1
 @State private var howOften : Double = 1.5
 HStack {
 Button("?") {
 UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound, .announcement]) { success, error in
 if success {
 print("All set!")
 } else if let error = error {
 print(error.localizedDescription)
 }
 }
 }
 
 
 
 OptionsButton(boundValue: $howMany, from: 1.0, by: 2, over: 4)
 OptionsButton(boundValue: $howOften, from: 1.5, by: 0.1, over: 6)
 
 let howManyInt = Int(self.howMany.rounded())
 let id = UUID().uuidString
 for number in 1..<howManyInt+1 {
 self.makeNot(id: id, title: String(number), subtitle: "out of " + String(howManyInt), timeInterval: 3 + Double(number) * self.howOften)
 }
 
 }
 
 func makeNot(id: String, title : String, subtitle : String, timeInterval : TimeInterval) {
 let content = UNMutableNotificationContent()
 content.title = title
 content.subtitle = subtitle
 content.sound = UNNotificationSound.default
 content.threadIdentifier = id
 content.body = "The time is now for " + title
 
 
 // show this notification five seconds from now
 let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
 
 // choose a random identifier
 let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
 
 // add our notification request
 UNUserNotificationCenter.current().add(request, withCompletionHandler: self.whatup)
 }
 
 func whatup(error: Error?) {
 if error != nil {
 print(error?.localizedDescription ?? "nil")
 }
 }
 */
