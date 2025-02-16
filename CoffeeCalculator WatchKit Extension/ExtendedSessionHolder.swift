//
//  ExtendedSessionHolder.swift
//  CoffeeCalculator WatchKit Extension
//
//  Created by Bill Paetzke on 2/11/20.
//  Copyright © 2020 Bill Paetzke. All rights reserved.
//

import Foundation
import WatchKit

final class ExtendedSessionHolder : NSObject, WKExtendedRuntimeSessionDelegate, ExtendedRuntimeSessionable  {
    
    private var runtimeSession = WKExtendedRuntimeSession()
    
    func start() {
        if (runtimeSession.state == .invalid)
        {
            runtimeSession = WKExtendedRuntimeSession()
        }
        runtimeSession.delegate = self
        runtimeSession.start()
    }
    
    func stop() {
        print("ES stopping")
        if (runtimeSession.state == .running)
        {
            runtimeSession.invalidate()
            print("ES stopped")
        }
    }
    
    func extendedRuntimeSessionDidStart(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        // Track when your session starts.
    }
    
    func extendedRuntimeSessionWillExpire(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        // Finish and clean up any tasks before the session ends.
    }
    func extendedRuntimeSession(_ extendedRuntimeSession: WKExtendedRuntimeSession, didInvalidateWith reason: WKExtendedRuntimeSessionInvalidationReason, error: Error?) {
        // Track when your session ends.
        // Also handle errors here.
    }
    
}
