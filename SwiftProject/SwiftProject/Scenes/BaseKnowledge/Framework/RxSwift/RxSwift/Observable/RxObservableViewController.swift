//
//  RxObservableViewController.swift
//  SwiftProject
//
//  Created by Ryan on 2020/6/23.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

/*
重点：
 1. 发送信号和订阅信号的时间序
 2. 多个信号一起协作
 3. 信号的转换
 */
class RxObservableViewController: BaseViewController {
    let disposeBag = DisposeBag()

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var button: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK:创建普通序列
    func creatObservable() -> Single<Any>{

        // 参数：创建序列时定义一个参数类型，block内部观察者调用方法时传递这个类型的参数，监听时拿到的就是这个参数
        let json: Observable<Any> = Observable.create { (observer) -> Disposable in

            let url = NSURL.init(string: "")
            guard let url1 = url else {
                return Disposables.create()
            }

            let request = URLRequest(url: url1 as URL)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard error == nil else {
                    observer.onError(error!)
                    return
                }

                guard let data = data, let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) else {
                    observer.onError(error!)
                    return
                }

                observer.onNext(jsonObject)
                observer.onCompleted()
            }
            task.resume()
            return Disposables.create ()
        }

        json.subscribe(onNext: { json in
            print("取得 json 成功: \(json)")
        }, onError: { error in
            print("取得 json 失败 Error: \(error.localizedDescription)")
        }, onCompleted: {
            print("取得 json 任务成功完成")
        })
            .disposed(by: disposeBag)

        //        // 转成Single序列
        //        json.asSingle().do(onSuccess: { _ in
        //        })

        return  json.asSingle()

        json.asSingle().subscribe(onSuccess: { (json) in

        }) { (error) in

        }
    }

    //MARK:特征序列
    //我理解的就是子序列，根据不同的序列特征（比如事件类型），选用不同的序列
    func single() {
        creatSingleObservable("ReactiveX/RxSwift").subscribe(onSuccess: { json in
            print("JSON: ", json)
        }, onError: { error in
            print("Error: ", error)
        })
            .disposed(by: disposeBag)
    }

    //Single：产生一个success或者产生一个 error 事件。适合HTTP 请求，然后返回一个response或错误
    func creatSingleObservable(_ repo: String) -> Single<[String: Any]> {
        return Single<[String: Any]>.create { singleObserver in
            let url = URL(string: "https://api.github.com/repos")!
            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                if let error = error {
//                    singleObserver(.error(error))
                    return
                }
                guard let data = data,let json = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves),let result = json as? [String: Any] else {
//                    singleObserver(.error(error!))
                    return
                }
                singleObserver(.success(result))
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }

    //Completable：产生一个 completed 事件或者产生一个 error 事件。适用于只关心任务是否完成而不需要任务返回值
    func completable() {
        creatCompletableObservable().subscribe(onCompleted: {
            print("Completed with no error")
        }, onError: { error in
            print("Completed with an error: \(error.localizedDescription)")
        })
            .disposed(by: disposeBag)
    }
    func creatCompletableObservable() -> Completable {
        return Completable.create { completableObserver in
            completableObserver(.completed)
            return Disposables.create {}
        }
    }

    //Maybe：只能发出一个元素，产生一个 completed 事件或者产生一个 error 事件
    func maybe() {
        let block = { (str: String) -> Void in
            print("Completed with element \(str)")
        }

        creatMaybeObservable().subscribe(onSuccess: block, onError: { error in
            print("Completed with an error \(error.localizedDescription)")
        }, onCompleted: {
            print("Completed with no element")
        })
            .disposed(by: disposeBag)
    }

    func creatMaybeObservable() -> Maybe<String> {
        return Maybe<String>.create { maybeObserver in
            maybeObserver(.success("RxSwift"))
            // OR
            maybeObserver(.completed)
            // OR
            maybeObserver(.error(NSError()))
            return Disposables.create {}
        }
    }

    //Driver：适用于更新UI。不会产生error事件，一定在 MainScheduler 监听（主线程监听），共享附加作用
    func driver() {
        let resultDriver = textField.rx.text.orEmpty.asDriver().flatMap {
            return dealwithData(inputText: $0).asDriver(onErrorJustReturn: "检测到了错误事件")
        }.map { $0 as! String} //把Any转为String

        //模拟网络请求，还模拟了在监测到错误输入后返回错误的请看
        func dealwithData(inputText:String)-> Observable<Any>{
            print("请求网络了 \(Thread.current)") // data
            return Observable<Any>.create({ (ob) -> Disposable in
                if inputText == "1234" {
                    ob.onError(NSError.init(domain: "com.error.cn", code: 10086, userInfo: nil))
                }
                //模拟网络请求发送时是子线程
                DispatchQueue.global().async {
                    print("发送之前看看: \(Thread.current)")
                    ob.onNext("已经输入:\(inputText)")
                    ob.onCompleted()
                }
                return Disposables.create()
            })
        }

        //订阅代码修改为：
        resultDriver.drive(self.button.rx.title())//给Btn赋值，模拟更新UI
    }

    func controlProperty() {
        /*

         ControlProperty 专门用于描述 UI 控件属性的，它具有以下特征：

         不会产生 error 事件
         一定在 MainScheduler 订阅（主线程订阅）
         共享附加作用

         */
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
}
