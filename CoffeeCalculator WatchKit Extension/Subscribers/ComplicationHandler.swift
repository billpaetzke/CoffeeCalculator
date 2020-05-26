//
//  ComplicationSubscriber.swift
//  CoffeeCalculator WatchKit Extension
//
//  Created by Bill Paetzke on 4/13/20.
//  Copyright © 2020 Bill Paetzke. All rights reserved.
//

import Foundation
import Combine
import ClockKit

final class ComplicationHandler {
    
    private var timerStateSubscriber : AnyCancellable?
    
    init(timerStatePublisher : Published<TimerHolder.State>.Publisher) {
        self.timerStateSubscriber = subscribe(timerStatePublisher: timerStatePublisher)
        
        //print("subscribed to timer state changes")
    }
    
    private func subscribe(timerStatePublisher : Published<TimerHolder.State>.Publisher) -> AnyCancellable {
        timerStatePublisher
            .receive(on: DispatchQueue.global())
            .dropFirst() // the @Published seems to be a current value publisher, and we only want new values
            .sink(receiveValue: {
                state in
                
                //print("received timer state: \(state)")
                
                if let activeComplications = CLKComplicationServer.sharedInstance().activeComplications {
                    for activeComplication in activeComplications {
                        CLKComplicationServer.sharedInstance().reloadTimeline(for: activeComplication)
                        //print("complication reloaded for: \(activeComplication.family)")
                    }
                }
            })
    }
}
