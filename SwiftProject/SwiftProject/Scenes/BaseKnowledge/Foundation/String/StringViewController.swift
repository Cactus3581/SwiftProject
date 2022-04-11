//
//  StringViewController.swift
//  SwiftProject
//
//  Created by Ryan on 2020/9/16.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class StringViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

//        let descObj = PrintDesc()
//        print(descObj.description)

        let text = "   你说你像花 却不容易掉落   \n 我说哎呀妈呀  \n"
        let a = removeCharSpace(text: text)
        print("text: \(a)")
    }

    // 去掉不合理的空格
    func removeCharSpace(text: String) -> String {
        var temp = text.trimmingCharacters(in: .whitespacesAndNewlines)
        temp = temp.replacingOccurrences(of: "\n", with: "", options: .literal, range: nil)
        temp = temp.replacingOccurrences(of: "\r", with: "", options: .literal, range: nil)
        let matchs = temp.components(separatedBy: " ").filter({ !$0.isEmpty })
        guard !matchs.isEmpty else { return temp }
        print("matchsmatchs: \(matchs)")
        return matchs.joined(separator: " ")
    }

    static var emojiRegExp: NSRegularExpression? = {
        let regex = "\\s{2,}"
        guard let regExp = try? NSRegularExpression(pattern: regex, options: [.caseInsensitive]) else {
            return nil
        }
        return regExp
    }()
}

// Mark: 结构体转json
struct TestJson {
    let name = "name1"
    let testJsonInObjc = TestJsonIn()
    struct TestJsonIn {
        let name = "name2"
    }
}


// Mark: 结构体转json
struct PrintDesc {
    let name = "name1"
    let isShow = true

    public var description: String {
        dictDescription.description
    }

    public var dictDescription: [String: String] {
        return [
            "keyName": name,
            "keyName": "name",
            "keyName": "\(name)",
            "isShow": "\(isShow)"]
    }
}
