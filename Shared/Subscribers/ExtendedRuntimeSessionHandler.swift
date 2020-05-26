//
//  ExtendedRuntimeSessionHandler.swift
//  CoffeeCalculator
//
//  Created by Bill Paetzke on 4/23/20.
//  Copyright © 2020 Bill Paetzke. All rights reserved.
//

import Foundation
import Combine

final class ExtendedRuntimeSessionHandler {
    
    private var timerStateSubscriber : AnyCancellable?
    private var elapsedTimeSubscriber : AnyCancellable?
    
    private var session : ExtendedRuntimeSessionable
    
    init(session: ExtendedRuntimeSessionable,
         timerStatePublisher : Published<TimerHolder.State>.Publisher,
         timerCountPublisher : Published<Int>.Publisher,
         timerPlanPublisher : Published<TimerPlan?>.Publisher) {
        self.session = session
        self.timerStateSubscriber = subscribe(timerStatePublisher: timerStatePublisher)
        self.elapsedTimeSubscriber = subscribe(timerCountPublisher: timerCountPublisher, timerPlanPublisher: timerPlanPublisher)
    }
    
    private func subscribe(timerStatePublisher : Published<TimerHolder.State>.Publisher) -> AnyCancellable {
        timerStatePublisher
            .receive(on: DispatchQueue.main)
            .subscribe(on: DispatchQueue.global(qos: .userInteractive))
            //.dropFirst() // the @Published seems to be a current value publisher, and we only want new values
            .sink(receiveValue: {
                timerState in
                
                //print("ES State Sub: timer: \(timerState)")
                
                switch timerState {
                case .running:
                    //print("ES State Sub: timer: \(timerState) starting ES")
                    self.session.start() // in imperative mode, I had extsession start happening before timer start; maybe try to get that back again in react mode
                case .stopped:
                    //print("ES State Sub: timer: \(timerState) stopping ES")
                    self.session.stop() // in imperative mode, I had extsession stop happen after timer stop, which is the case here; so we are good
                default:
                    //print("ES State Sub: timer: \(timerState) do nothing w/ ES")
                    break; // TODO handle all states
                }
            })
    }
    
    private func subscribe(timerCountPublisher : Published<Int>.Publisher, timerPlanPublisher : Published<TimerPlan?>.Publisher) -> AnyCancellable {
        Publishers.CombineLatest(timerCountPublisher, timerPlanPublisher)
            .filter({ $1 != nil})
            .receive(on: DispatchQueue.main)
            .subscribe(on: DispatchQueue.global(qos: .userInteractive))
            .sink(receiveValue: {
                count, plan in
                
                //print("ES Sub: \(count)s \(plan!.title)")
                
                guard let instructions = plan?.instructions else { return }
                
                if instructions.isEnd(at: count - 3) {
                    /* 3 seconds after end */
                    self.session.stop()
                }
            })
    }
    
    
}
