//
//  BPSubViewController.swift
//  swiftProject
//
//  Created by 夏汝震 on 2019/12/5.
//  Copyright © 2019 ryan. All rights reserved.
//

import UIKit

class BPTestController: UIViewController {

    let a:Int = 5
//    a = 6
//    a = 6

    let b:Int = 0
    var c = 0


    override func viewDidLoad() {
        super.viewDidLoad()
        let vc = BPSubViewController()
        print(vc.name,vc.onetitle)

    }
}

class BPSubViewController: UIViewController {

    //存储型属性 - 需要开辟空间，以存储数据
    //计算型属性 - 不分配独立的存储空间保存计算结果，只是执行函数返回其他内存地址

    // private只能在当前类访问
    fileprivate var onetitle: String? = ""

    private var _name: String?
    var name: String? {
        get {
            return _name
        }
        set {
            onetitle = ""
            _name = newValue
        }
    }

    // 只实现 getter 方法的属性被称为计算型属性，等同于 OC 中的 ReadOnly 属性.

    // 计算型属性:get方法
    var str: String {

        get {
            return "getter" + (name ?? "")
        }
    }

    //计算型属性:可以使用以下代码简写
    var str1: String  {
        return "getter" + (name ?? "")
    }

    // 存储属性：以闭包的形式返回
    var str2: String = {
        return "getter1"
    }()

    //Swift通常使用didSet代替OC的setter
    var str3: String? {
        didSet {
        // dosomething
        }
    }



    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.pushViewController(CarViewController(), animated: true)

        onetitle = ""
        TestBridge().test()

//        let defaults =  UserDefaults.standard

//        defaults.set(true, forKey: "1")
//        defaults.set(10, forKey: "2")
//        defaults.set(10.10, forKey: "3")
//        defaults.set(1000000.10, forKey: "4")
//        defaults.set(NSURL.fileURL(withPath: "www.gg.com"), forKey: "5")
//        defaults.set("2", forKey: "6")
//
//        defaults.bool(forKey: "1")
//        defaults.integer(forKey: "2")
//        defaults.float(forKey: "3")
//        defaults.double(forKey: "4")
//        defaults.url(forKey: "5")
//        defaults.object(forKey: "6")
    }
}
