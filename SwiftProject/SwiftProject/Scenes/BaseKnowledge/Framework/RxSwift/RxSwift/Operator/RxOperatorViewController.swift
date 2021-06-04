//
//  RxOperatorViewController.swift
//  SwiftProject
//
//  Created by Ryan on 2020/6/23.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


/*
 疑惑点：
 throttle
 distinctUntilChanged
 flatMapLatest
 */

class RxOperatorViewController: BaseViewController {
    let disposeBag = DisposeBag()

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // 操作符是序列的方法，也就是针对序列使用的。使用操作符将原有的序列转化为一个你想要的新的序列，可以帮助大家创建新的序列，或者变化组合原有的序列，从而生成一个新的序列。
    func useOperator() {
        //map转换：将源 Observable 的每个元素应用你提供的转换方法，然后返回含有转换结果的 Observable。
        Observable.of(1, 2, 3).map { $0 * 10 }.subscribe(onNext: { print($0) }).disposed(by: disposeBag)
        // 把返回的String类型map成UIColor类型
        _ = textField.rx.text.map({ (value) -> UIColor in
            if let value = value , value.count > 5 {
                return UIColor.red
            } else {
                return UIColor.green
            }
        }).subscribe(onNext: { [unowned self] (color) in
            self.textField.textColor = color
        })

        //filter过滤:将通过你提供的判断方法过滤一个 Observable，然后使用新的序列执行后面的subscribe方法
        Observable.of(2, 30, 22, 5, 60, 1).filter { $0 > 10 }.subscribe(onNext: { print($0) }).disposed(by: disposeBag)
        _ = textField.rx.text.filter({ (value) -> Bool in
            if let value = value , value.count > 3 {
                return true
            }
            return false
        }).subscribe(onNext: { (text) in
            print("==========\(text!)")
        })

        //zip配对:通过一个函数将多个(最多不超过8个) Observables 的元素组合起来，然后将这个组合的结果发出来。它会严格的按照序列的索引数进行组合
        let first = PublishSubject<String>()
        let second = PublishSubject<String>()
        Observable.zip(first, second) { $0 + $1 }.subscribe(onNext: { print($0) }).disposed(by: disposeBag)
        first.onNext("1")
        second.onNext("A")
        first.onNext("2")
        second.onNext("B")
        second.onNext("C")
        second.onNext("D")
        first.onNext("3")
        first.onNext("4")

    }

    /*
     1. 组合多个序列
     2. 当任何一个序列发出元素，会连带其他序列暂存中的最新元素也发出来
     3. 前提是这些 Observables 每个都曾经发出过元素
     4. 返回值是什么
     */
    func combineLatest() {

        let first = PublishSubject<String>()
        let second = PublishSubject<String>()

        Observable.combineLatest(first, second) { $0 + $1 }
                  .subscribe(onNext: { print($0) })
                  .disposed(by: disposeBag)

        first.onNext("1")
        second.onNext("A")
        first.onNext("2")
        second.onNext("B")
        second.onNext("C")
        second.onNext("D")
        first.onNext("3")
        first.onNext("4")

        /*
         输出结果：
         1A
         2A
         2B
         2C
         2D
         3D
         4D
         */
    }

    /*
     直到订阅发生，才创建 Observable，并且为每位订阅者创建全新的 Observable
     */
    func deferred() {

    }

    /*
     阻止 Observable 发出相同的元素
     */
    func distinctUntilChanged() {
        Observable.of("🐱", "🐷", "🐱", "🐱", "🐱", "🐵", "🐱")
        .distinctUntilChanged()
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)

        /*
         输出结果：
         🐱
         🐷
         🐱
         🐵
         🐱
         */
    }

    /*
     当 Observable 的某些事件产生时，你可以使用 do 操作符来注册一些回调操作。这些回调会被单独调用，它们会和 Observable 原本的回调分离。
     */
    func _do() {

    }


    /*
     仅仅发出 Observable 中符合判断条件的元素
     */
    func filter() {
        Observable.of(2, 30, 22, 5, 60, 1)
        .filter { $0 > 10 }
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)

        /*
         输出结果：
         30
         22
         60
         */
    }

    /*
     将 Observable 的元素转换成其他的 Observable，然后将这些 Observables 合并
     */
    func flatMap() {
        let first = BehaviorSubject(value: "👦🏻")
        let second = BehaviorSubject(value: "🅰️")
//        let variable = Variable(first)
//
//        variable.asObservable()
//                .flatMap { $0 }
//                .subscribe(onNext: { print($0) })
//                .disposed(by: disposeBag)

        first.onNext("🐱")
//        variable.value = second
        second.onNext("🅱️")
        first.onNext("🐶")

        /*
         输出结果：
         👦🏻
         🐱
         🅰️
         🅱️
         🐶
         */
    }

    /*
     将 Observable 的元素转换成其他的 Observable，然后取这些 Observables 中最新的一个
     */
    func flatMapLatest() {
        let first = BehaviorSubject(value: "👦🏻")
        let second = BehaviorSubject(value: "🅰️")
//        let variable = Variable(first)

//        variable.asObservable()
//                .flatMapLatest { $0 }
//                .subscribe(onNext: { print($0) })
//                .disposed(by: disposeBag)

        first.onNext("🐱")
//        variable.value = second
        second.onNext("🅱️")
        first.onNext("🐶")
        /*
         输出结果：
         👦🏻
         🐱
         🅰️
         🅱️
         */
    }

    /*
     创建 Observable 发出唯一的一个元素
     */
    func just() {
        let id = Observable.just(0)

        // 它相当于：
        let id1 = Observable<Int>.create { observer in
            observer.onNext(0)
            observer.onCompleted()
            return Disposables.create()
        }
    }

    /*
     将 Observable 的每个元素转换一遍
     */
    func map() {
        let id = Observable.just(0)

        // 它相当于：
        let id1 = Observable<Int>.create { observer in
            observer.onNext(0)
            observer.onCompleted()
            return Disposables.create()
        }
    }

    func merge() {

    }

    func observeOn() {

    }

    func reduce() {

    }

    func repeatElement() {

    }

    func single() {

    }
    func skip() {

    }
    func subscribeOn() {

    }


    func takeUntil() {

    }
    func withLatestFrom() {

    }

    func zip() {

    }
}
