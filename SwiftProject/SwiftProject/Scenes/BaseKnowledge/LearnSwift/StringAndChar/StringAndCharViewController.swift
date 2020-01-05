//
//  StringAndCharViewController.swift
//  SwiftProject
//
//  Created by ryan on 2020/1/3.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class StringAndCharViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK:使用字面量初始化
        let anotherEmptyString = String()
        let emptyString = ""

        if emptyString.isEmpty {
            print("empty")
        }


        // MARK:多行字符串
        var quotation = """
        hello,
        word
        """
        print(quotation)

        quotation = """
        hello,\
        word
        """
        print(quotation)

        let softWrappedQuotation = """
        a "b \
        c
        "d"e \
        f"
        """
        print(softWrappedQuotation)

        // MARK:字符串里的特殊字符->需要使用\来转义

        quotation = """
        空字符\0,反斜杠\\,水平制表符\t,换行符\n,回车符\r,双引号\",单引号\'
        """
        print(quotation)

        let threeDoubleQuotationMarks = """
        Escaping the first quotation mark \"""
        Escaping all three quotation marks \"\"\"
        """
        print(threeDoubleQuotationMarks)

        //MARK:操作字符
        //Character值能且只能包含一个字符
        let exclamationMark: Character = "!"
        print(exclamationMark)
        let catCharacters: [Character] = ["C", "a", "t", "!", "🐱️"]
        let catString = String(catCharacters)
        print(catString)

        //遍历 String 中的每一个独立的 Character值：
        for character in "Dog!🐶️" {
            print(character)
        }


        //MARK:字符串拼接
        let string1 = "a"
        let string2 = "b"
        var string3 = string1 + string2
        let string4 = "c"
        string3 += string4
        string3.append("d")
        print(string3)

        //MARK:字符串插值:\(),值可以是任何类型
        let multiplier = 3
        let message = "\(multiplier) times 2.5 is \(Double(multiplier) * 2.5)"
        print(message)

        //MARK:访问和修改字符串
        //字符串索引
        let greeting = "Guten Tag!"
        greeting[greeting.startIndex]// G
        greeting[greeting.index(before: greeting.endIndex)]// !
        greeting[greeting.index(after: greeting.startIndex)]// u
        let index = greeting.index(greeting.startIndex, offsetBy: 7)
        greeting[index]// a














    }
}
