//
//  AppDelegate.swift
//  SwiftProject
//
//  Created by Ryan on 2019/12/18.
//  Copyright © 2019 cactus. All rights reserved.
//

import UIKit

// 11
// diyici

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // diyici
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        ProfileAssembly.profileRegister()
        BPListAssembly.profileRegister()
        
        print("DidFinishLaunch")
        
            
        
        
        

        
        return true
    }
//1
//2
//3
//4


    //a
    //b

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


        //master
    }

    func applicationDidFinishLaunching(_ application: UIApplication) {
        print("DidFinishLaunching")
    }

    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        print("DidReceiveMemoryWarning")
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

