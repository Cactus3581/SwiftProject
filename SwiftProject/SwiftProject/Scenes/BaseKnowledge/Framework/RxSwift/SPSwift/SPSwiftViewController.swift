//
//  SPSwiftViewController.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/8.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class SPSwiftViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        observer()
    }

    func observer() {
        // 创建一个可观察对象
        let observable = SPObservable{(observer) -> Void in
            // 第一个闭包：让观察者调用方法
            observer.next(value: "zcj")
        }

        let closure = {(value: String) -> Void in
            // 第二个闭包：观察者抛出到这里
            print(value)

        }

        observable.subscribe(eventHandler: closure)

        func map(source: SPObservable, transform: @escaping (_ value: String) -> String) -> SPObservable {

            let observable = SPObservable.init{ (observer) -> Void in
                let closure = {(value: String) -> Void in
                    let transformedValue = transform(value)
                    observer.next(value: transformedValue)
                }
                source.subscribe(eventHandler: closure)
            }
//            let observable = SPObservable{(observer) -> Void in
//                let closure = {(value: String) -> Void in
//                    let transformedValue = transform(value)
//                    observer.next(value: transformedValue)
//                }
//                source.subscribe(eventHandler: closure)
//            }
            return observable
        }

        map(source: observable) { (value) -> String in
            return "hi " + value
        }.subscribe(eventHandler: closure)
    }
}
