//
//  ControlFlowViewController.swift
//  SwiftProject
//
//  Created by ryan on 2020/1/3.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class ControlFlowViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK:switch
        let point = (2, 2)
        switch point {
            case (0, 0):
                print("point is (0, 0)")
            case (_, 0): //_匹配所有可能的值
                print("point is (_, 0)")
            case (0, _):
                print("point is (0, _)")
            case (0...3, 0...3):
                print("point is the scope of (0...3, 0...3)")
            default:
                print("not in the scope of ... ")
        }

        //值绑定
        //case 分⽀的模式允许将匹配的值绑定到⼀个临时的常量或变量，这些常量或变量在该case 分⽀⾥就可以被引⽤了
        let anotherPoint = (2, 0)
        switch anotherPoint {
            case (let x, 0): //匹配纵坐标是0的点，并将横坐标的值赋予x，下同
                print("on the x-axis with an x value of \(x)")
            case (0, let y):
                print("on the y-axis with a y value of \(y)")
            case let (x, y): //匹配所有
                print("somewhere else at (\(x), \(y))")
        }

        //case分支的模式可以使用where语句来判断额外的条件
        let yetAnotherPoint = (1, -1)
        switch yetAnotherPoint {
            case let (x, y) where x == y: //匹配x等于y的所有情况，下同
                print("(\(x), \(y)) is on the line x == y")
            case let (x, y) where x == -y:
                print("(\(x), \(y)) is on the line x == -y")
            case let (x, y):
                print("(\(x), \(y)) is just some arbitrary point")
        }

        // 匹配多个值
        let someCharacter: Character = "e"
        switch someCharacter {
        case "a", "b", "c":
            print("\(someCharacter) is a vowel")
        case "d", "e", "f":
            print("\(someCharacter) is a consonant")
        default:
            print("\(someCharacter) is not a vowel or a consonant")
        }
    }
}
