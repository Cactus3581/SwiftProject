//
//  RxDisposableViewController.swift
//  SwiftProject
//
//  Created by Ryan on 2020/6/23.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RxDisposableViewController: BaseViewController {
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK:释放资源
    // 释放资源(订阅的生命周期)
    /*
     当一个序列发出了 error 或者 completed 事件时，所有内部资源都会被释放。如果需要提前释放这些资源或取消订阅，可以对返回的 可被清除的资源（Disposable） 调用 dispose 方法。
     subscribe和bind方法的返回值是Disposable类型，拿到Disposable，然后调用dispose方法，订阅将被取消，并且内部资源都会被释放。通常情况下，你是不需要手动调用 dispose 方法。我们推荐使用 清除包（DisposeBag） 或者 takeUntil 操作符 来管理订阅的生命周期。

     disposeBag：disposeBag 一般和 ViewController 具有相同的生命周期。当退出页面时， ViewController 就被释放，disposeBag 也跟着被释放了，那么这里的 5 次绑定（订阅）也就被取消了。
     */
    func disposable() {
        let subject = PublishSubject<String>()

        var disposeBag = subject.subscribe { text in

        }
        disposeBag.dispose()

        //另外一种实现自动取消订阅的方法就是使用 takeUntil 操作符，这将使得订阅一直持续到控制器的 dealloc 事件产生为止。
        subject.takeUntil(self.rx.deallocated).subscribe { text in

        }
    }

}
