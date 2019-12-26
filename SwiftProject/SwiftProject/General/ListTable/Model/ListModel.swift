//
//  ListModel.swift
//  SwiftProject
//
//  Created by Ryan on 2019/12/19.
//  Copyright © 2019 cactus. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON

//完成情况
enum BPCompletePerformance : Int {
    case none //没有开始写
    case doing //在写
    case willDone //将要完成
    case done //已完成
}

//重要程度
enum BPImportance : Int {
    case regular //一般的
    case medium //中等的
    case high
}

class ListModel: NSObject, HandyJSON {

    var title: String?
    var fileName: String?
    var subVc_array:[ListModel]?

    //以下是非必需的字段
    var dynamicJumpString: String?/*动态跳转数据 */
    var briefIntro: String?/* 简短说明 */
    var planIntro: String?/*进度补充说明 */
    var url: String?/*web地址 */
    var completePerformance: BPCompletePerformance!/*完成情况 */
    var importance: BPImportance!//涉及的知识重要程度

    required override init() {}

    func mapping(mapper: HelpingMapper) {
        //写法一
        //mapper <<<
            //self.id <-- "cat_id"
        //写法二
            //mapper.specify(property: &id, name: "cat_id")
    }

    // 这里面积area中就不能再用arrayValue获取了，因为arrayValue获取的为JSON类型，我们需要转为我们需要的对象
    init(jsonData: JSON) {
        title = jsonData["title"].stringValue
        fileName = jsonData["fileName"].stringValue
//        subVc_array = jsonData["subVc_array"].arrayObject as! [AnyHashable]
        dynamicJumpString = jsonData["dynamicJumpString"].stringValue
        briefIntro = jsonData["briefIntro"].stringValue
    }
}
