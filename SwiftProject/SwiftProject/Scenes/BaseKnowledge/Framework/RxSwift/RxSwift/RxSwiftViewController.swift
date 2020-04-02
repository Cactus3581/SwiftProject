//
//  RxSwiftViewController.swift
//  SwiftProject
//
//  Created by ryan on 2019/12/26.
//  Copyright © 2019 cactus. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa



class RxSwiftViewController : BaseViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    dynamic var nameStr: String = "test" // 初始化属性


    override func viewDidLoad() {
        super.viewDidLoad()
//        targetAction()
        dsada()
    }

    func targetAction()  {

        let disposeBag = DisposeBag()

        //MARK:点击事件
        loginButton.rx.tap.subscribe(onNext: {
            print("button Tapped")
        }).disposed(by: disposeBag)


        _ = loginButton.rx.controlEvent(UIControl.Event.touchUpInside).subscribe(onNext: { [unowned self] in
            print(self)
        })

        //MARK:代理
//        scrollView.rx.contentOffset
//        .subscribe(onNext: { contentOffset in
//            print("contentOffset: \(contentOffset)")
//        })
//        .disposed(by: disposeBag)

        // 监听UITextField的内容变化(剪切、粘贴、删除所有的内容都会触发改方法)
        //  subscribe方法只需要一个onNext 参数，其他的参数可以不理会（手动删除其他参数就是下面的代码的样子了）
         _ = usernameTextField.rx.text.subscribe(onNext: { (text) in
                print(text ?? "")
          })

        //MARK:闭包回调
        URLSession.shared.rx.data(request: URLRequest(url: NSURL.init(fileURLWithPath: "") as URL))
        .subscribe(onNext: { data in
            print("Data Task Success with count: \(data.count)")
        }, onError: { error in
            print("Data Task Error: \(error)")
        })
        .disposed(by: disposeBag)


        //MARK:通知
        // 发送通知
        NotificationCenter.default.post(name: Notification.Name(rawValue: "kNotificationTestName"), object: "testContent")

        // 接收通知
        //.takeUntil(self.rx.deallocated).作用是：保证页面销毁的时候移除通知
         _ = NotificationCenter.default.rx.notification(Notification.Name("kNotificationTestName")).takeUntil(self.rx.deallocated).subscribe(onNext: {[unowned self] (value) in
                    print(value)
                })

        //MARK:KVO
        //  不能用observe 否则会引起循环引用
        _ = self.rx.observeWeakly(String.self, "nameStr").subscribe(onNext: { (value) in
                   print(value ?? "")
            })

        // CGRect等类型不能用observeWeakly，否则监听不到
        _ = self.usernameTextField.rx.observe(CGRect.self, "frame").subscribe(onNext: { (value) in
                    print("frame====\(String(describing: value))")
            })

        //MARK:map的用法
        // 把返回的String类型map成UIColor类型
        _ = usernameTextField.rx.text.map({ (value) -> UIColor in
                  if let value = value , value.count > 5 {
                      return UIColor.red
                  } else {
                      return UIColor.green
                  }
           }).subscribe(onNext: { [unowned self] (color) in
                  self.usernameTextField.textColor = color
           })

        //MARK:filter的用法
        // 筛选符合一点条件的情况下才执行下面的subscribe方法
        _ = usernameTextField.rx.text.filter({ (value) -> Bool in
                    if let value = value , value.count > 3 {
                        return true
                    }
                    return false
                }).subscribe(onNext: { (text) in
                    print("==========\(text!)")
                })

        //MARK:RxSwift - 绑定
        //Rx的重要角色为Observable（被观察者）和Observer（观察者）
        // 把UITextField里的文字赋值给UIButton(把被观察者的值赋值给观察者)
        // UITextField的rx.text属性为ControlProperty类型，实现了ControlPropertyType: ObservableType, ObserverType，所以不仅是观察者类型，还是被观察者类型
        _ = self.usernameTextField.rx.text.bind(to: self.loginButton.rx.title(for: .normal)) // 这样文本框输入的内容就会自动设置成按钮的标题了。

        //MARK:多个任务之间有依赖关系
        /// 用 Rx 封装接口
//        enum API {
//            /// 通过用户名密码取得一个 token
//            static func token(username: String, password: String) -> Observable<String> {
//                return ""
//            }
//
//            /// 通过 token 取得用户信息
//            static func userInfo(token: String) -> Observable<NSDictionary> {
//                return ["":""]
//            }
//        }
//
//        /// 通过用户名和密码获取用户信息
//        API.token(username: "beeth0ven", password: "987654321")
//            .flatMapLatest(API.userInfo)
//            .subscribe(onNext: { userInfo in
//                print("获取用户信息成功: \(userInfo)")
//            }, onError: { error in
//                print("获取用户信息失败: \(error)")
//            })
//            .disposed(by: disposeBag)
//
//        //MARK：等待多个并发任务完成后处理结果
//        /// 用 Rx 封装接口
//        enum API1 {
//            /// 取得老师的详细信息
//            static func teacher(teacherId: Int) -> Observable<String> {}
//
//            /// 取得老师的评论
//            static func teacherComments(teacherId: Int) -> Observable<[String]> { }
//        }
//
//        /// 同时取得老师信息和老师评论
//        Observable.zip(
//              API1.teacher(teacherId: 10000),
//              API1.teacherComments(teacherId: 10000)
//            ).subscribe(onNext: { (teacher, comments) in
//                print("获取老师信息成功: \(teacher)")
//                print("获取老师评论成功: \(comments.count) 条")
//            }, onError: { error in
//                print("获取老师信息或评论失败: \(error)")
//            })
//            .disposed(by: disposeBag)

    }

    func dsada() {

        let numbers: Observable<Int> = Observable.create{ observer -> Disposable in
            observer.onNext(0)
            observer.onNext(1)
            observer.onNext(2)
            observer.onNext(3)
            observer.onNext(4)
            observer.onNext(5)
            observer.onNext(6)
            observer.onNext(7)
            observer.onNext(8)
            observer.onNext(9)
            observer.onCompleted()
            return Disposables.create()
        }
        numbers.subscribe(onNext: { number in
            print(number)
        }, onError: { error in
            print("发生错误： \(error.localizedDescription)")
        }, onCompleted: {
            print("任务完成")
        })

        let disposeBag = DisposeBag()
        Observable.of(2, 30, 22, 5, 60, 1).filter {
            $0 > 10
        }.subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)
    }
}
