//
//  SceneDelegate.swift
//  SwiftProject
//
//  Created by Ryan on 2019/12/18.
//  Copyright © 2019 cactus. All rights reserved.
//

import UIKit


// f1


//mine
//mine
//mine

//lark-1
//lark-10
//master -11
//master -20
//develop -20
//master -21
//master -30
//master -301


class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    

        //由于 swift 中的类属性都是 lazy 方式求值的, 所以需要在 AppDelegate 中先引用一次, 以保证 container 中的所有注册内容都是在程序最开始就运行:
//    let container = BPContainer.container
    //2

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        
        
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        self.window = UIWindow(windowScene: scene as! UIWindowScene)
        
        

        
        
        
        
        
        
        
        
        self.window?.frame = UIScreen.main.bounds
        //当你操作可选项(带?)的值的时候，比如方法，属性和下标：如果 ?前的值是 nil，那 ?后的所有内容都会被忽略并且整个表达式的值都是 nil。否则，可选项的值将被展开，然后 ?后边的代码根据展开的值执行。

        self.window?.backgroundColor = UIColor.white
        self.window?.rootViewController = RootTabBarController.init()
        self.window?.makeKeyAndVisible()

    //        baseuse(vc: vc)
        guard let _ = (scene as? UIWindowScene) else { return }
    }


        func baseuse(vc:TestViewController) {

//            // 通过在类名字后边添加一对圆括号来创建一个类的实例
//            // 使用点语法来访问实例里的属性和方法。
//            vc.ivarString = "ivarString"
//            vc.ivarNum = 2
//
//            vc.simple()
//            //        vc.control()
//            vc.func1()
//            let string = vc.func2(var1: "1", var2: 2)
//            print(string);
//
//            // 打印属性
//            print(vc.ivarNum,vc.ivarString);
//
//            print(vc.perimeter) // getter
//            vc.perimeter = 1// setter
//            print(vc.ivarNum)
//
//            print(vc.perimeter1) // getter
//            vc.perimeter1 = 1// setter
//            print(vc.ivarNum)
//
//            print(vc.ivarString)
//
//            vc.enumFunc()
//            vc.protocolFunc()
//            vc.errorFunc()
//            //        vc.optional()
//            TestViewController.classMethod()
        }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        print("将进入前台")
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        print("已变成活跃")
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        print("将取消活跃")
        print("将取消活跃")
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        print("已进入后台")
        print("已进入后台")
    }
}
