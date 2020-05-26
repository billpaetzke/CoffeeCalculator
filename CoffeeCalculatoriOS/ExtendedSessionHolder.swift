//
//  ExtendedSessionHolder.swift
//  CoffeeCalculatoriOS
//
//  Created by Bill Paetzke on 4/23/20.
//  Copyright © 2020 Bill Paetzke. All rights reserved.
//

import Foundation
import UIKit

final class ExtendedSessionHolder : ExtendedRuntimeSessionable  {
        
    func start() {
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    func stop() {
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    /*
    func extendedRuntimeSessionDidStart(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        // Track when your session starts.
    }
    
    func extendedRuntimeSessionWillExpire(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        // Finish and clean up any tasks before the session ends.
    }
    func extendedRuntimeSession(_ extendedRuntimeSession: WKExtendedRuntimeSession, didInvalidateWith reason: WKExtendedRuntimeSessionInvalidationReason, error: Error?) {
        // Track when your session ends.
        // Also handle errors here.
    }*/
    
}

