//
//  CarViewController.swift
//  SwiftProject
//
//  Created by Ryan on 2019/12/15.
//  Copyright © 2019 cactus. All rights reserved.
//

import UIKit

class CarViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let container = BPContainer.container
        let car = container.resolve(Driver.self)!
//        let car2 = container.resolve(Driver.self, arguments: "Sedan", true)!

        car.drive()
    }
}

//将 PetOwner 类修改为依赖于 Animal 协议接口, 而非具体的 Cat 类
class Driver {

    var car: CarService? = nil


//    init(car: CarService) {
//        self.car = car
//    }

    func drive() {
        print("I'm drive with \(car!.run).")
    }

    func configCar(car: CarService) {
       self.car = car
    }
}

protocol CarService {
//    var carName: String { get set }

    func run()
}

// 轿车
class Sedan:CarService {

    weak var parent: Driver?

    func run() {
        print("轿车开始接人")
    }
}

// 货车
class Trucks:CarService {
    func run() {
        print("货车开始运输")
    }
}
