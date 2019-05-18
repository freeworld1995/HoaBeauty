//
//  AppDelegate.swift
//  FCA
//
//  Created by 1 on 8/6/18.
//  Copyright © 2018 FCA2018. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//        UIApplication.shared.statusBarStyle = .lightContent
        ManagerGoogleDrive.shared.setup()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey:Any]) -> Bool {
        if GAuthorizer.shared.continueAuthorization(with: url) {
            return true
        }
        // (There will be other callback checks here for the likes of Dropbox etc...)
        return false
    }
    
}

