//
//  SwinjectViewController.swift
//  swiftProject
//
//  Created by 夏汝震 on 2019/12/11.
//  Copyright © 2019 ryan. All rights reserved.
//

import UIKit


class PersonViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let conQueue = DispatchQueue(label: "concurrentQueue1",attributes:.concurrent)

        let container = BPContainer.container
        //2. 从容器中获取服务实例
        let person = container.resolve(Person.self)!
        person.play()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let container = BPContainer.container
        container.resetObjectScope(BPContainer.user)
    }
}

// 3. 定义协议和类
protocol Animal {
    var name: String? { get }
}

class Cat: Animal {
    let name: String?

    init(name: String?) {
        self.name = name
    }
}

class Dog: Animal {
    let name: String?

    init(name: String?) {
        self.name = name
    }
}

protocol Person {
    func play()
}

//将 PetOwner 类修改为依赖于 Animal 协议接口, 而非具体的 Cat 类
class PetOwner: Person {

    let pet: Animal

    init(pet: Animal) {
        self.pet = pet
    }

    func play() {
        let name = pet.name ?? "someone"
        print("I'm playing with \(name).")
    }
}


