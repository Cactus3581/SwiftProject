//
//  ClassStructViewController1.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2021/8/1.
//  Copyright © 2021 cactus. All rights reserved.
//

import Foundation
import UIKit

class ClassStructViewController1: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let item = UIBarButtonItem(title:"show",
                                   style:.plain,
                                   target:self,
                                   action:#selector(click1))
        self.navigationItem.rightBarButtonItem = item
    }
    
    @objc
    func click1() {
        //测试：修改最底层模型的普通变量
        var one = StructOneModel()
        
        // 方法1: 直接修改，结果报错: Cannot assign to property: 'first' is a get-only property
        //one.oneList.first?.twoList.first?.threeName = "1"
        one.oneList[0].twoList[0].threeName = "1"
        print(one.oneList.first?.twoList.first?.threeName)

        // 方法2:copy下修改，结果原来的模型没有修改成功
        var three = one.oneList.first?.twoList.first
        three?.threeName = "1"
        print(one.oneList.first?.twoList.first?.threeName)
        
        // 方法3:一层一层的修改。使用外面赋值修改
        three?.threeName = "2"
        var twoModels = one.oneList
        var two = twoModels.first
        
        // copy 出来修改，再放回去
//        var threeModels = two?.twoList
//        threeModels?[0] = three!
//        two?.twoList = threeModels!
        
        // 不copy，直接原地修改
        two?.twoList[0] = three!
        // 不copy，直接原地修改，插入
        two?.twoList.append(three!)
        
        twoModels[0] = two!
        one.oneList = twoModels
        print(one.oneList.first?.twoList.first?.threeName)
        print(one.oneList.first?.twoList.last?.threeName)

        // 方法4:一层一层的修改。内部使用mutaing修改
        three?.threeName = "3"
        one.updateThreeModel(three!)
        print(one.oneList.first?.twoList.first?.threeName)
        
        one.twoModel.twoName = "1"
        one.oneList.append(one.twoModel)
        one.oneList = []
        
        one.twoModel.twoList.append(three!)
        one.twoModel.twoList = []
        print(one.twoModel.twoName)
    }
    
    @objc
    func click2() {
        var threeModel = StructThreeModel()
        threeModel.threeName = "a"
        var list = [threeModel]
        threeModel.threeName = "b"
        print(list.first?.threeName)
    }
}
