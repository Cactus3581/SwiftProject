//
//  RxSubjectViewController.swift
//  SwiftProject
//
//  Created by Ryan on 2020/6/23.
//  Copyright © 2020 cactus. All rights reserved.
//


import UIKit
import RxSwift
import RxCocoa

class RxSubjectViewController: BaseViewController {

    let disposeBag = DisposeBag()
    let subject1 = PublishSubject<String>()
    let subject2 = PublishSubject<String>()

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func testZip() {
        subject2.onNext("a")
        subject2.onNext("b")
        subject2.onNext("c")

//        var localBag = DisposeBag()
        Observable.zip(subject1.asObservable(), subject2.asObservable())
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] a, b in
                print("aaaaaa: \(a), b: \(b)")
//                localBag = DisposeBag()
            }).disposed(by: self.disposeBag)

        subject2.onNext("d")
        subject2.onNext("e")
        subject2.onNext("f")
        subject1.onNext("A")
        subject2.onNext("g")
        subject2.onNext("h")
        subject1.onNext("B")
    }

    //MARK:订阅方法
    //subscribe对应的观察者有next/complete/error事件。bind对应的观察者只有next事件
    func bind() {

    }

    //MARK:序列和观察者Subject
    //既是可监听序列也是观察者。如果你能合适的应用这些辅助类型，它们就可以帮助你更准确的描述事物的特征
    func creatAsyncSubject() {
        //AsyncSubject 只会发出最后一个元素，如果源 Observable 没有发出任何元素，只有一个完成事件。那 AsyncSubject 也只有一个完成事件。
        let subject = AsyncSubject<String>()
        subject.subscribe { print("Subscription: 1 Event:", $0) }.disposed(by: disposeBag)

        subject.onNext("🐶")
        subject.onNext("🐱")
        subject.onNext("🐹")
        subject.onCompleted()
        // 🐹onCompleted
    }

    func creatPublishSubject() {
        //在订阅前发出的元素将不会发送给观察者

        let disposeBag = DisposeBag()
        let subject = PublishSubject<String>()

        subject.subscribe { print("Subscription: 1 Event:", $0) }.disposed(by: disposeBag)

        subject.onNext("🐶")
        subject.onNext("🐱")

        subject
            .subscribe { print("Subscription: 2 Event:", $0) }
            .disposed(by: disposeBag)

        subject.onNext("🅰️")
        subject.onNext("🅱️")

        // 🐶🐱🅰️🅰️🅱️🅱️
    }

    func creatReplaySubject() {
        //将对观察者发送全部的元素，无论观察者是何时进行订阅的。
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
        // 🐶🐱🐱🅰️🅰️🅱️🅱️ 缺个🐶，也不是最新的啊
    }

    func creatBehaviorSubject() {

        //当观察者对 BehaviorSubject 进行订阅时，它会将源 Observable 中最新的元素发送出来（如果不存在最新的元素，就发出默认元素）。然后将随后产生的元素发送出来。
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
        // 🔴🐶🐱🐱🅰️🅰️🅱️🅱️🅱️🍐🍐🍐🍊🍊🍊
    }


    func behaviorRelay() {
        //创建一个初始值为111的BehaviorRelay
        let relay = BehaviorRelay<String>(value: "111")

        //修改value值
        relay.accept("222")
        relay.accept("333")

        //第1次订阅
        relay.asObservable().skip(0).subscribe {
            print("第1次订阅：", $0)
        }.disposed(by: disposeBag)

        //修改value值
        relay.accept("333")

        //第2次订阅
        relay.asObservable().subscribe {
            print("第2次订阅：", $0)
        }.disposed(by: disposeBag)

        //修改value值
        relay.accept("444")
    }
}
