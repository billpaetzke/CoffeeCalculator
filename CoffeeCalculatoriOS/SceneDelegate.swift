//
//  SceneDelegate.swift
//  CoffeeCalculatoriOS
//
//  Created by Bill Paetzke on 4/1/20.
//  Copyright © 2020 Bill Paetzke. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private var extendedRuntimeSessionHandler: ExtendedRuntimeSessionHandler!
    private var hapticsHandler: HapticsHandler!
    private var timerSubscriber : TimerSubscriber!
    private let timerPlanModel = TimerPlanModel(plans: [
        TimerPlan(title: "Rao", stages: [
            TimerPlanStage(pourRate: 5, duration: 17),
            TimerPlanStage(pourRate: 0, duration: 35),
            TimerPlanStage(pourRate: 5, duration: 20),
            TimerPlanStage(pourRate: 0, duration: 35),
            TimerPlanStage(pourRate: 5, duration: 18),
            TimerPlanStage(pourRate: 0, duration: 35),
            TimerPlanStage(pourRate: 5, duration: 19),
            TimerPlanStage(pourRate: 0, duration: 61),
        ]),
        TimerPlan(title: "4:6", stages: [
            TimerPlanStage(pourRate: 6, duration: 10),
            TimerPlanStage(pourRate: 0, duration: 35),
            TimerPlanStage(pourRate: 6, duration: 10),
            TimerPlanStage(pourRate: 0, duration: 35),
            TimerPlanStage(pourRate: 6, duration: 10),
            TimerPlanStage(pourRate: 0, duration: 35),
            TimerPlanStage(pourRate: 6, duration: 10),
            TimerPlanStage(pourRate: 0, duration: 35),
            TimerPlanStage(pourRate: 6, duration: 10),
            TimerPlanStage(pourRate: 0, duration: 20),
        ]),
        TimerPlan(title: "Dre", stages: [
            TimerPlanStage(pourRate: 4, duration: 9),
            TimerPlanStage(pourRate: 0, duration: 23),
            TimerPlanStage(pourRate: 4, duration: 16),
            TimerPlanStage(pourRate: 0, duration: 21),
            TimerPlanStage(pourRate: 4, duration: 15),
            TimerPlanStage(pourRate: 0, duration: 16),
            TimerPlanStage(pourRate: 4, duration: 13),
            TimerPlanStage(pourRate: 0, duration: 16),
            TimerPlanStage(pourRate: 4, duration: 15),
            TimerPlanStage(pourRate: 0, duration: 16),
        ]),
        TimerPlan(title: "Aero Joe", stages: [
            TimerPlanStage(pourRate: 20, duration: 10),
            TimerPlanStage(pourRate: 0, duration: 40),
            TimerPlanStage(pourRate: 0, duration: 10),
            TimerPlanStage(pourRate: 0, duration: 5),
            TimerPlanStage(pourRate: 0, duration: 30),
        ])
    ])
    private let brewPlanModel = BrewPlanModel()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        extendedRuntimeSessionHandler = ExtendedRuntimeSessionHandler(
            session: ExtendedSessionHolder(),
            timerStatePublisher: TimerHolder.sharedInstance.$state,
            timerCountPublisher: TimerHolder.sharedInstance.$count,
            timerPlanPublisher: timerPlanModel.$selectedPlan)
        
        hapticsHandler = HapticsHandler(
            hapticsEnabledPublisher: timerPlanModel.$areHapticsEnabled,
            timerCountPublisher: TimerHolder.sharedInstance.$count,
            timerPlanPublisher: timerPlanModel.$selectedPlan)
        
        timerSubscriber = TimerSubscriber(
            speechVolumePublisher: timerPlanModel.$speechVolume,
            timerCountPublisher: TimerHolder.sharedInstance.$count,
            timerPlanPublisher: timerPlanModel.$selectedPlan)
        
        // Get the managed object context from the shared persistent container.
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        // Create the SwiftUI view and set the context as the value for the managedObjectContext environment keyPath.
        // Add `@Environment(\.managedObjectContext)` in the views that will need the context.
        let contentView = ContentView(brewPlanModel: brewPlanModel,
                                      timerHolder: TimerHolder.sharedInstance,
                                      timerPlanModel: timerPlanModel)
            .environment(\.managedObjectContext, context)

        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

