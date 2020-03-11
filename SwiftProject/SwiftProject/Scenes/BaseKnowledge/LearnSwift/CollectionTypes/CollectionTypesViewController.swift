//
//  CollectionTypesViewController.swift
//  SwiftProject
//
//  Created by ryan on 2020/1/3.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

// 等号右部分：如果创建一个空的集合，需要标记出具体类型来并使用初始化方法；如果不是一个空的集合，不需要明确标记出类型来，可以直接使用字面量
// 等号左部分：如果等号右部分已经明确类型了，等号左部分就不需要明确标记类型了

class CollectionTypesViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        array()
        set()
        dictionary()
    }

    //MARK:数组Array<Element>
    func array() {

        //创建一个空数组
        let array6 = Array<Int>() //初始化器语法
        print(array6)

        var array = [Int]() //初始化器语法
        array = [] // 如果内容已经提供了类型信息，可以用空的字面量创建空数组：

        //创建一个非空数组
        //字面量创建：
        var array1: [String] = ["Eggs", "Milk"]
        var array2 = ["Eggs", "Milk"] //简写

        //使用默认值创建数组：
        var array3 = Array(repeating: 0.0, count: 3) // 初始化器语法，确定数组大小且元素都设定为相同默认值
        var array4 = array1 + array2 // 通过连接两个数组来创建数组
    }

    //MARK:setSet<Element>
    func set() {
        //创建一个空合集
        var set = Set<Int>()//初始化器语法
        set = []//使用字面量：如果内容已经提供了类型信息，可以用空的字面量来创建一个空合集：

        //字面量创建
        var set1: Set<String> = ["Rock", "Classical", "Hip hop"]
        var set2: Set = ["Rock", "Classical", "Hip hop"]  //简写：因为合集类型不能从字面量推断出来，所以 Set 类型必须被显式地声明
    }

    //MARK:字典Dictionary<Key, Value> 简写： [Key: Value]
    func dictionary() {

        //创建一个空字典
        var dict3 = Dictionary<Int,String>()//用初始化器
        var dict = [Int: String]()//用初始化器
        dict = [:]//使用字面量：如果内容已经提供了类型信息，可以用空的字面量创建空字典

        //字面量创建：
        var dict1: [String: String] = ["YYZ": "Toront", "DUB": "Dublin"]
        var dict2 = ["YYZ": "Toront", "DUB": "Dublin"]//简写
    }
}
