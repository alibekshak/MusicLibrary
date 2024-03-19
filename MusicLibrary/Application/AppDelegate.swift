//
//  AppDelegate.swift
//  MusicLibrary
//
//  Created by Alibek Shakirov on 19.03.2024.
//

import Foundation
import UIKit

@main
class AppDelegate: NSObject, UIApplicationDelegate {
    var window: UIWindow?
    var appCoordinator: AppCoordinator!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        appCoordinator = AppCoordinator(window: window)
        appCoordinator.start()
        window.makeKeyAndVisible()
        
        return true
    }
}
