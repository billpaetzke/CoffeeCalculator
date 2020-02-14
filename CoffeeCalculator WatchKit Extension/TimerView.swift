//
//  TimerView.swift
//  CoffeeCalculator WatchKit Extension
//
//  Created by Bill Paetzke on 1/21/20.
//  Copyright © 2020 Bill Paetzke. All rights reserved.
//

import SwiftUI
import AVFoundation
import Combine

struct TimerView: View {
    @State var brewWeight = 0
    @State var iteration = 0
    let audioSession = AVAudioSession.sharedInstance()
    let synth = AVSpeechSynthesizer()
    
    let timer = Timer.publish(every: 3, on: .main, in: .common)
    
    @State var cancellable: Cancellable?
    
    var body: some View {
        
        VStack {
            Text("\(brewWeight)")
                .font(.title)
                .onReceive(timer) {_ in
                    if (self.iteration == 0)
                    {
                        let utter = AVSpeechUtterance(string: "0 grams @ 5 grams / second")
                        utter.voice = AVSpeechSynthesisVoice(language: "en-US")
                        utter.volume = Float(1.0)
                        utter.rate = utter.rate * 1
                        self.synth.speak(utter)
                    }
                    else if (self.iteration <= 2 || self.iteration >= 14) {
                        self.brewWeight = self.brewWeight + 15
                        
                        let utter = AVSpeechUtterance(string:
                            (self.brewWeight / 100 == 0 ? "" : String(self.brewWeight / 100))
                                + " " +
                                (self.brewWeight % 100 == 0 ? String(self.brewWeight) : String(self.brewWeight % 100)))
                        utter.voice = AVSpeechSynthesisVoice(language: "en-US")
                        utter.volume = Float(1.0)
                        utter.rate = utter.rate * 1
                        self.synth.speak(utter)
                        
                        if (self.brewWeight >= 390) {
                            
                            self.cancellable?.cancel()
                            
                            let utter = AVSpeechUtterance(string: "@ 0 grams / second. 390 @ 0 grams / second.")
                            utter.voice = AVSpeechSynthesisVoice(language: "en-US")
                            utter.volume = Float(1.0)
                            utter.rate = utter.rate * 1
                            self.synth.speak(utter)
                        }
                    }
                    
                    if (self.iteration == 3)
                    {
                        self.brewWeight = self.brewWeight + 15
                        let utter = AVSpeechUtterance(string: "45 grams @ 0 grams / second")
                        utter.voice = AVSpeechSynthesisVoice(language: "en-US")
                        utter.volume = Float(1.0)
                        utter.rate = utter.rate * 1
                        self.synth.speak(utter)
                    }
                    
                    if (self.iteration == 12)
                    {
                        let utter = AVSpeechUtterance(string: "45 grams @ 0 grams / second")
                        utter.voice = AVSpeechSynthesisVoice(language: "en-US")
                        utter.volume = Float(1.0)
                        utter.rate = utter.rate * 1
                        self.synth.speak(utter)
                    }
                    
                    if (self.iteration == 13)
                    {
                        let utter = AVSpeechUtterance(string: "45 grams @ 5 grams / second")
                        utter.voice = AVSpeechSynthesisVoice(language: "en-US")
                        utter.volume = Float(1.0)
                        utter.rate = utter.rate * 1
                        self.synth.speak(utter)
                    }
                    
                    self.iteration = self.iteration + 1
                    
            }
            
            
            Button(action: {
                                
                self.cancellable = self.timer.connect()
            }) {
                Text("Start")
            }
            
            Button(action: {
                self.cancellable?.cancel()
                
                self.brewWeight = 0
                self.iteration = 0
            }) {
                Text("Stop")
            }
            
            
        }
        
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
    }
}
