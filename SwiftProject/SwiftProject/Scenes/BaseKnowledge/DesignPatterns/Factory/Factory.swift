//
//  Factory.swift
//  SwiftProject
//
//  Created by ryan on 2020/1/4.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

/*

简单工厂：只有一个工厂,根据参数来生成产品；新增产品类，必须更改主类代码
一般工厂：(必须使用继承/协议) 多个工厂，新增产品类，需要新建工厂类；但是一个工厂只有一个产品；
抽象工厂：(必须使用继承/协议) 新增产品类，需要新建工厂类，还要新增新的创建产品的方法，还要在头文件中声明这个方法 相比一般工厂，一个工厂可以有多个产品；

*/

protocol ProduceProtocol {
    var name:String{get}
}

extension ProduceProtocol {
    var name:String {
        return ""
    }
}

class Factory1: NSObject {
    static func factory(type:Int) -> ProduceProtocol {
        if type == 0 {
            return Produce()
        }
        return Produce()
    }
}

protocol FactoryProtocol {
    static func factory() -> ProduceProtocol
    static func factory41() -> ProduceProtocol
    static func factory42() -> ProduceProtocol
}

extension FactoryProtocol {
    static func factory() -> ProduceProtocol {
        return Produce()
    }
    static func factory41() -> ProduceProtocol {
        return Produce()
    }
    static func factory42() -> ProduceProtocol {
        return Produce()
    }
}

class Factory2: FactoryProtocol {
    static func factory() -> ProduceProtocol {
        return Produce()
    }
}

class Factory3: FactoryProtocol {
    static func factory() -> ProduceProtocol {
        return Produce1()
    }
}

class Factory4: FactoryProtocol {

    static func factory41() -> ProduceProtocol {
        return Produce()
    }

    static func factory42() -> ProduceProtocol {
        return Produce1()
    }
}

