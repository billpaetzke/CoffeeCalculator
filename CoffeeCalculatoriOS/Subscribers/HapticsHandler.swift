//
//  HapticsHandler.swift
//  CoffeeCalculatoriOS
//
//  Created by Bill Paetzke on 4/29/20.
//  Copyright © 2020 Bill Paetzke. All rights reserved.
//

import Foundation
import Combine

final class HapticsHandler {
    
    private var areHapticsEnabled = true
    private var hapticsEnabledSubscriber : AnyCancellable?
    private var hapticsTimingSubscriber : AnyCancellable?
    private var hapticHolder: HapticHolder = HapticHolder()
    
    init(hapticsEnabledPublisher: Published<Bool>.Publisher,
         timerCountPublisher : Published<Int>.Publisher,
         timerPlanPublisher : Published<TimerPlan?>.Publisher) {
        self.hapticsEnabledSubscriber = subscribe(hapticsEnabledPublisher: hapticsEnabledPublisher)
        self.hapticsTimingSubscriber = subscribe(timerCountPublisher: timerCountPublisher, timerPlanPublisher: timerPlanPublisher)
        self.hapticHolder.createAndStartHapticEngine()
    }
    
    private func subscribe(hapticsEnabledPublisher: Published<Bool>.Publisher) -> AnyCancellable {
        hapticsEnabledPublisher
            .receive(on: DispatchQueue.main)
            .subscribe(on: DispatchQueue.global(qos: .userInteractive))
            .sink(receiveValue: {
                areHapticsEnabled in
                
                self.areHapticsEnabled = areHapticsEnabled
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
                
                if !self.areHapticsEnabled { return }
                guard let instructions = plan?.instructions else { return }
                
                let instructionNow = instructions.get(at: count)
                let instructionNext = instructions.get(at: count + 3) /* instruction 3 sec in future */
                let isEndTime = instructions.isEnd(at: count)
                
                if count == 0 || instructionNow?.isPouringStart(at: count) ?? false {
                    
                    self.hapticHolder.play(.start)
                    
                }
                else if instructionNext != nil && instructionNext != instructionNow {
                    
                    let direction : HapticHolder.HapticType = instructionNext!.isPouring ? .directionUp : .directionDown
                    self.hapticHolder.play(direction)
                }
                else if instructionNow?.isRestingStart(at: count) ?? false {
                    
                    self.hapticHolder.play(.stop)
                    
                }
                else if isEndTime {
                    
                    self.hapticHolder.play(.success)
                    
                }
            })
    }
}
