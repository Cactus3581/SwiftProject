//
//  RootTabBarController.swift
//  SwiftProject
//
//  Created by Ryan on 2019/12/19.
//  Copyright © 2019 cactus. All rights reserved.
//

import UIKit

class RootTabBarController: UITabBarController {

    private let kFeatureCatalog = "FeatureCatalog"
    
    private let kBasicKnowledgCatalog = "BasicKnowledgCatalog"
    private let kImprovingTipCatalog = "ImprovingTipCatalog"

    override func viewDidLoad() {
        super.viewDidLoad()
        addChildViewController()

        // Do any additional setup after loading the view.
    }
    /**
     *  添加所有子控制器方法
     */
    func addChildViewController() {

        let featureVC = UIViewController();
//        featureVC.url = kFeatureCatalog;
        setUpChildViewController(viewController: featureVC, image: UIImage.init(named: "tabbar_hotScenes")!, title: "场景")

        let baseKnowledgeVC = ListViewController();
        baseKnowledgeVC.url = kBasicKnowledgCatalog;
        setUpChildViewController(viewController: baseKnowledgeVC, image: UIImage.init(named: "tabbar_knowledge")!, title: "知识点")

        let improvingTipVC = UIViewController();
//        improvingTipVC.url = kImprovingTipCatalog;
        setUpChildViewController(viewController: improvingTipVC, image: UIImage.init(named: "tabbar_skill")!, title: "技巧")
    }

    /**
     *  添加一个子控制器的方法
     */
    func setUpChildViewController(viewController: UIViewController, image: UIImage, title:String) {
        viewController.view.backgroundColor = UIColor.white;
        let navC = RootNavigationController.init(rootViewController: viewController);
        navC.title = title;
        viewController.navigationItem.title = title;
        navC.tabBarItem.image = image;
        navC.tabBarItem.selectedImage = image;
        addChild(navC)
    }

}
