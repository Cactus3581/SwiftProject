//
//  MethodViewController.swift
//  SwiftProject
//
//  Created by ryan on 2020/1/3.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class MethodViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


        // Do any additional setup after loading the view.
    }

}

class Test: NSObject {
    var name:String?

        // 自定义的类创建的实例对象属于引用类型，不需要使用 mutating
    func change(name:String) {
        self.name = name
    }
}

struct Test1 {
    var name:Int?
    // 自定义的结构体创建的实例属于值类型，不能直接更改它的属性m，需要使用 mutating
    mutating func change(name:Int) {
        self.name = name
    }
}
