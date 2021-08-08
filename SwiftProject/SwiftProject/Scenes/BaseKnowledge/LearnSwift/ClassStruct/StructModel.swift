//
//  StructOneModel.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2021/7/14.
//  Copyright © 2021 cactus. All rights reserved.
//

import Foundation

struct StructOneModel {
    var oneName = "one"
    var oneList = [StructTwoModel]()
    var twoModel = StructTwoModel()
    var list = [Int]()
    var isMain = false

    init() {
        var threeModel1 = StructThreeModel()
        threeModel1.threeName = "three-1"
        
        var threeModel2 = StructThreeModel()
        threeModel2.threeName = "three-2"
        
        var two1 = StructTwoModel()
        two1.twoName = "two-1"
        two1.twoList = [threeModel1]
        
        var two2 = StructTwoModel()
        two2.twoName = "two-2"
        two2.twoList = [threeModel2]
        
        self.oneList = [two1, two2]
    }
    
    mutating func updateOneName(_ oneName: String) {
        self.oneName = oneName
    }
    
    mutating func updateThreeModel(_ threeModel: StructThreeModel) {
        // 直接修改 也会报错self.list.first?.list[0] = threeModel
        var firsttwo = self.oneList.first
        var threeModels = firsttwo?.twoList
        threeModels?[0] = threeModel
        firsttwo?.twoList = threeModels!
        self.oneList[0] = firsttwo!
    }
}

struct StructTwoModel {
    var twoName = "two"
    var twoList = [StructThreeModel]()
}

struct StructThreeModel {
    var threeName: String = "three"
    mutating func update(threeModel: String) {
        self.threeName = threeModel
    }
}
