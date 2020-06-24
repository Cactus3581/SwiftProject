//
//  RxReplaceCocoaSignalViewController.swift
//  SwiftProject
//
//  Created by Ryan on 2020/4/2.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

// 替代传统的事件传递


class RxReplaceCocoaSignalViewController: BaseViewController {

    let disposeBag = DisposeBag()
    dynamic var nameStr: String = "test" // 初始化属性

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK:订阅方法
    //subscribe对应的观察者有next/complete/error事件。bind对应的观察者只有next事件
    func bind() {
        
    }

    //MARK:由RXCocoa封装的UI控件
    func wrap() {
        // 作为可监听序列
        let observable = textField.rx.text
        observable.subscribe(onNext: { text in print(text) })
        
        // 按钮点击序列
        let taps: Observable<Void> = button.rx.tap.asObservable()
        // 每次点击后弹出提示框
        taps.subscribe(onNext: {
            print("tap")
        })
    }

    // MARK: button 点击事件
    func buttonClick() {
        // 第一种
        button.rx.tap.subscribe(onNext: {
            print("button Tapped")
        }).disposed(by: disposeBag)

        // 第二种
        button.rx.controlEvent(UIControl.Event.touchUpInside).subscribe(onNext: { [unowned self] in
            print(self)
        })
    }
    // MARK: 代理
    func delegate() {
        scrollView.rx.contentOffset
            .subscribe(onNext: { contentOffset in
                print("contentOffset: \(contentOffset)")
            })
            .disposed(by: disposeBag)

        // 监听UITextField的内容变化(剪切、粘贴、删除所有的内容都会触发改方法)
        // subscribe方法只需要一个onNext 参数，其他的参数可以不理会（手动删除其他参数就是下面的代码的样子了）
        textField.rx.text.subscribe(onNext: { (text) in
            print(text ?? "")
        })
    }

    // MARK: 闭包回调
    func block() {
        //闭包回调
        let request = URLRequest(url: NSURL.init(fileURLWithPath: "") as URL)
        URLSession.shared.rx.data(request: request)
            .subscribe(onNext: { data in
                print("Data Task Success with count: \(data.count)")
            }, onError: { error in
                print("Data Task Error: \(error)")
            })
            .disposed(by: disposeBag)
    }

    // MARK: 通知
    func notificationCenter() {
        // 发送通知
        NotificationCenter.default.post(name: Notification.Name(rawValue: "kNotificationTestName"), object: "testContent")
        // 接收通知，.takeUntil(self.rx.deallocated).作用是：保证页面销毁的时候移除通知
        NotificationCenter.default.rx.notification(Notification.Name("kNotificationTestName")).takeUntil(self.rx.deallocated).subscribe(onNext: { notification in
            print(notification)
        })
    }

    // MARK: KVO
    func kvo() {
        //  不能用observe 否则会引起循环引用
        self.rx.observeWeakly(String.self, "nameStr").subscribe(onNext: { (value) in
            print(value ?? "")
        })

        // CGRect等类型不能用observeWeakly，否则监听不到
        textField.rx.observe(CGRect.self, "frame").subscribe(onNext: { (value) in
            print("frame = \(String(describing: value))")
        })
    }
}
