//
//  JSONViewController.swift
//  SwiftProject
//
//  Created by Ryan on 2020/10/12.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit
import SwiftyJSON

class JSONViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let dict = [
            "list": [["songName":"name-1"],["songName":"name-2"]],
            "art": ["artName": "artName-a"],
            "album": ["albumA": ["name": "a"]],
            "level1": ["artName": "artName-a"],
        ] as [String : Any]

        let json = JSON(dict)

        let model = TestMusics(json: json)
        print(json)
        print(model)

        guard let json1 = JSONViewController.toJson(model) else { return }
        let dict1 = JSONViewController.toDict(json1)
        print(dict1)
    }

    /// JSON字符串转字典
    static func toDict(_ jsonString: String) -> Dictionary<String, Any>? {
        guard let jsonData = jsonString.data(using: .utf8) else { return nil }
        guard let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers), let result = dict as? Dictionary<String, Any> else { return nil }
        return result
    }

    /// 字典转模型
    static func toModel<T>(_ type: T.Type, value: Any) -> T? where T : Decodable {
        guard let data = try? JSONSerialization.data(withJSONObject: value) else {return nil }
        let decoder = JSONDecoder()
        decoder.nonConformingFloatDecodingStrategy = .convertFromString(positiveInfinity: "+Infinity", negativeInfinity: "-Infinity", nan: "NaN")
        return try? decoder.decode(type, from: data)
    }

    /// 模型转JSON字符串
    static func toJson<T>(_ model: T) -> String? where T : Encodable {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        guard let data = try? encoder.encode(model) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

struct TestMusics: Encodable {
    let list: [TestSong]
    let art: TestArt
    let level: String
    let album: [String: TestAlbum]
    let level1: [String: String]

    init(json: JSON) {
        self.list = json["list"].arrayValue.map{TestSong(json: $0)}
        self.art = TestArt(json: json["art"])
        self.level = json["level"].stringValue

        self.album = json["album"].dictionaryValue.mapValues({ (json) in
            return TestAlbum(json: json)
        })

        self.level1 = json["level1"].dictionaryValue as? [String: String] ?? [:]

//        self.level1 = (json["level1"].dictionaryObject ?? [:]) as [String: String]

//        self.album = json["album"].dictionaryValue.mapValues({ (json) in
//            return TestAlbum(json: json)
//        })
    }
}

struct TestSong: Encodable {
    let songName: String
    init(json: JSON) {
        self.songName = json["songName"].stringValue
    }
}

struct TestArt: Encodable {
    let artName: String
    init(json: JSON) {
        self.artName = json["artName"].stringValue
    }
}

struct TestAlbum: Encodable {
    let name: String
    init(json: JSON) {
        self.name = json["name"].stringValue
    }
}
