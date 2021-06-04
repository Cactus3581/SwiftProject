//
//  RxObserverViewController.swift
//  SwiftProject
//
//  Created by Ryan on 2020/6/23.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class RxObserverViewController: BaseViewController {
    let disposeBag = DisposeBag()

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK:创建观察者
        /* 创建观察者
         1. 和 Observable 一样，框架已经帮我们创建好了许多常用的观察者。例如：view 是否隐藏，button 是否可点击， label 的当前文本，imageView 的当前图片等等。
         2. 自定义观察者
         2.1 创建观察者最基本的方法，写一个闭包作为观察者
         2.2 创建特征观察者， 和 Observable 一样，观察者也存在特征观察者，比如AnyObserver和Binder
         */

        //AnyObserver 可以用来描叙任意一种观察者。
        func creatAnyObserver() {
            let observer: AnyObserver<Data> = AnyObserver { (event) in
                switch event {
                case .next(let data):
                    print("Data Task Success with count: \(data.count)")
                case .error(let error):
                    print("Data Task Error: \(error)")
                default:
                    break
                }
            }

            let url = NSURL.init(string: "")
            guard let url1 = url else {
                return
            }
            URLSession.shared.rx.data(request: URLRequest(url: url1 as URL))
                .subscribe(observer)
                .disposed(by: disposeBag)
        }


        func creatBinderObserver() {
            /* 演变：
             1. 使用bind和系统观察者
             2. 使用bind和AnyObserver
             3. 使用bind和Binder
             */

            //观察者。这个观察者是一个 UI 观察者，所以在响应事件时，只会处理 next 事件，并且更新 UI 的操作需要在主线程上执行。
            let observer: AnyObserver<String> = AnyObserver { [weak self] (event) in
                switch event {
                case .next(let text):
                    print("get = \(text)")
                    //收到发出的索引数后显示到label上
                    self?.label.text = text
                default:
                    break
                }
            }

            /*
             Binder 主要有以下两个特征：
             1. 确保绑定都是在给定 Scheduler 上执行（默认 MainScheduler）
             2. 不会处理错误事件
             */
            let observer1: Binder<String> = Binder(self.label) { (target, value) in
                print("get = \(value)")
                target.text = value
            }

            //Observable序列（每隔1秒钟发出一个索引数）
//            let observable = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
    //        observable
    //            .map { "当前索引数：\($0 )"}
    //            .bind(to: observer)
    //            .disposed(by: disposeBag)

//            observable
//                .map { "当前索引数：\($0 )"}
//                .do(onNext: { (text) in
//                    print("do(onNext\(text)")
//                }, afterNext: { (text) in
//                    print("do(afterNext\(text)")
//                }, onError: nil, afterError: nil, onCompleted: nil, afterCompleted: nil, onSubscribe: nil, onSubscribed: nil, onDispose: nil)
//                .bind(to: observer)
//                .disposed(by: disposeBag)


            // 把UITextField里的文字赋值给UIButton(把被观察者的值赋值给观察者)
            // button的rx.title属性为ControlProperty类型，所以不仅是观察者类型，还是被观察者类型
            textField.rx.text.bind(to: self.button.rx.title(for: .normal)) // 这样文本框输入的内容就会自动设置成按钮的标题了。
        }

}
