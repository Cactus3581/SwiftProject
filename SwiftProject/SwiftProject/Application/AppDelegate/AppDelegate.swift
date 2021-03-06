//
//  AppDelegate.swift
//  SwiftProject
//
//  Created by Ryan on 2019/12/18.
//  Copyright © 2019 cactus. All rights reserved.
//

import UIKit
#if DEBUG
    import DoraemonKit
#endif

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let window = UIWindow()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window.frame = UIScreen.main.bounds
        self.window.backgroundColor = UIColor.white
        self.window.rootViewController = RootTabBarController.init()
        self.window.makeKeyAndVisible()
        #if DEBUG
               DoraemonManager.shareInstance().install()
               DoraemonManager.shareInstance().install(withStartingPosition: CGPoint(x: 100, y: 100))
        #endif
        print("DidFinishLaunch")
        return true
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        print("将进入前台")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        print("已变成活跃")
    }

    func applicationWillResignActive(_ application: UIApplication) {
        print("将取消活跃")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        print("已进入后台")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        print("WillTerminate")
    }

    func applicationDidFinishLaunching(_ application: UIApplication) {
        print("DidFinishLaunching")
    }

    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        print("DidReceiveMemoryWarning")
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
