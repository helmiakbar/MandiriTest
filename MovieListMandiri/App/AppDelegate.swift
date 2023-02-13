//
//  AppDelegate.swift
//  MovieListMandiri
//
//  Created by SehatQ on 12/02/23.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        app.router.launchMainView()
        return true
    }
}

