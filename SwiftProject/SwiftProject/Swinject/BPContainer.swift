//
//  BPContainer.swift
//  swiftProject
//
//  Created by 夏汝震 on 2019/12/11.
//  Copyright © 2019 ryan. All rights reserved.
//

import UIKit
import Swinject

/*
 1. 编写协议和遵守该协议的类，在类里实现协议方法；
 2. 注册：提供一个实例对象，时机必须往前；
 3. 通过容器获取实例对象，并调调用方法
 */
class BPContainer: NSObject {

    static let user: ObjectScope = {
        let user = ObjectScope(storageFactory: Swinject.PermanentStorage.init)
        return user
    }()

    override init() {
        super.init()
    }

    /* 服务（协议）、组件（类）、容器
    1. 将服务应该注册到应用程序的AppDelegate中的容器中，其中组件由注册的闭包作为工厂创建。在本例中，Cat和PetOwner分别是实现Animal和Person服务协议的组件类。
    */

    func getUsr() -> ObjectScope {
        return BPContainer.user
    }

    static let container: Container = {

        // 将服务注册到创建的容器中,并从闭包中创建一个对象
        let container = Container()

        //注册：注册service以及提供实例化方法

        container.register(CarService.self) {_ in
            Sedan()
        }

        container.register(CarService.self) {_ in
            Trucks()
        }

        // 避免循环引用
        container.register(CarService.self) { _ in Sedan() }
        .initCompleted { r, c in
            let child = c as! Sedan
            child.parent = r.resolve(Driver.self)
        }

        //如果class B的实例对于class A是optional的，就可以通过setter注入。

        container.register(Driver.self) { resolver in
            //初始化注入
            //Driver(car: resolver.resolve(CarService.self)!)
            let driver = Driver()
            // 属性注入
//            driver.car = resolver.resolve(CarService.self)
            // 方法注入
            driver.configCar(car: resolver.resolve(CarService.self)!)
            return driver
        }

        //允许给同一个service注册不同的实现
//        container.register(CarService.self,name: "Sedan") {_ in
//            Sedan()
//        }
//
//        container.register(CarService.self,name: "Trucks") {_ in
//            Trucks()
//        }
//
//        container.register(Driver.self) { resolver in
//            Driver(car: resolver.resolve(CarService.self,arguments:"Sedan",true)!)
//        }

        // ----

        container.register(Animal.self) { _ in
            Cat(name: "Mimi")
        }

        container.register(Animal.self) { _ in
            Dog(name: "wangwang")
        }

        //初始化注入:，如果class A的初始化必须要用class B的实例
        container.register(Person.self) { resolver in
            PetOwner(pet: resolver.resolve(Animal.self)!)
            //PetOwner(pet: resolver.resolve(Animal.self) ?? Cat(name: "Mimi"))
        }.inObjectScope(.container)


//        container.register(PersonViewController.self) { resolver in
//            let controller = PersonViewController()
//            controller.person = resolver.resolve(Person.self)
//            return controller
//        }

        return container
    }()
}
