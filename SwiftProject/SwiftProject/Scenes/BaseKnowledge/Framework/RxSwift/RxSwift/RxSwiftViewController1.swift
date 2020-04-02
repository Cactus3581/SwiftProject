//
//  RxSwiftViewController1.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2020/4/1.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RxSwiftViewController1: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupObservable()

    }

    //MARK:创建序列
    func setupObservable() {

//        // 创建序列最直接的方法就是调用 Observable.create
//        let numbers: Observable<Int> = Observable.create { observer -> Disposable in
//            observer.onNext(0)//产生了一个元素，他的值是 0
//            observer.onNext(1)
//            observer.onNext(2)
//            observer.onNext(3)
//            observer.onNext(4)
//            observer.onNext(5)
//            observer.onNext(6)
//            observer.onNext(7)
//            observer.onNext(8)
//            observer.onNext(9)
//            //用 observer.onCompleted() 表示元素已经全部产生，没有更多元素了。
//            observer.onCompleted()
//            return Disposables.create()
//        }
//
//
//        numbers.subscribe(onNext: { number in
//            print(number)
//        }, onError: { error in
//            print("发生错误： \(error.localizedDescription)")
//        }, onCompleted: {
//            print("任务完成")
//        })

 /// 直接使用序列发送事件没有意义
        let disposeBag = DisposeBag()
        Observable.just("🔴").subscribe { event in
            print(event)
        }.disposed(by: disposeBag)
    }


//    let subject = PublishSubject<String>()
//    subject.subscribe {
//        print($0)
//    }.disposed(by: disposeBag) // 原生订阅方法
//    /// 发送事件🐶
//    subject.onNext("🐶")
//    /// 发送事件🐱
//    subject.onNext("🐱")
    /// 打印结果

    //MARK:Subject

    //在订阅前发出的元素将不会发送给观察者
    func publishSubject() {
        let disposeBag = DisposeBag()
        let subject = PublishSubject<String>()

        subject
          .subscribe { print("Subscription: 1 Event:", $0) }
          .disposed(by: disposeBag)

        subject.onNext("🐶")
        subject.onNext("🐱")

        subject
          .subscribe { print("Subscription: 2 Event:", $0) }
          .disposed(by: disposeBag)

        subject.onNext("🅰️")
        subject.onNext("🅱️")
    }


    //将对观察者发送全部的元素，无论观察者是何时进行订阅的。如果把 ReplaySubject 当作观察者来使用，注意不要在多个线程调用 onNext, onError 或 onCompleted。这样会导致无序调用，将造成意想不到的结果。
    func replaySubject() {
        let disposeBag = DisposeBag()
        let subject = ReplaySubject<String>.create(bufferSize: 1)

        subject
          .subscribe { print("Subscription: 1 Event:", $0) }
          .disposed(by: disposeBag)

        subject.onNext("🐶")
        subject.onNext("🐱")

        subject
          .subscribe { print("Subscription: 2 Event:", $0) }
          .disposed(by: disposeBag)

        subject.onNext("🅰️")
        subject.onNext("🅱️")
    }

    func behaviorSubject() {
        let disposeBag = DisposeBag()
        let subject = BehaviorSubject(value: "🔴")

        subject
          .subscribe { print("Subscription: 1 Event:", $0) }
          .disposed(by: disposeBag)

        subject.onNext("🐶")
        subject.onNext("🐱")

        subject
          .subscribe { print("Subscription: 2 Event:", $0) }
          .disposed(by: disposeBag)

        subject.onNext("🅰️")
        subject.onNext("🅱️")

        subject
          .subscribe { print("Subscription: 3 Event:", $0) }
          .disposed(by: disposeBag)

        subject.onNext("🍐")
        subject.onNext("🍊")
    }

}
