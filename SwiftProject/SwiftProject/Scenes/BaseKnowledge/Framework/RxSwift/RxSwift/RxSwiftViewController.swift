//
//  RxSwiftViewController.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2020/4/2.
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

class RxSwiftViewController: BaseViewController {
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    dynamic var nameStr: String = "test" // 初始化属性
    let disposeBag = DisposeBag()
    lazy var test1 : UILabel =  {
        return UILabel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.addSubview(test1)
        creatBinderObserver()
        //        self.test1.text = "dsadsadasd"
        //        self.test1.backgroundColor = UIColor.green
        //        self.test1.snp.makeConstraints { (make) in
        //            make.center.equalTo(self.view)
        //        }
        //
        //        test1.removeFromSuperview()
        //        useOperator()
    }
    
    //MARK:创建序列
    func creatObservable() {
        
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
        
        // 转成Single序列
        json.asSingle().do(onSuccess: { _ in
        })



        json.asSingle().subscribe(onSuccess: { (json) in
            
        }) { (error) in
            
        }
    }
    
    //MARK:特征序列
    //我理解的就是子序列，根据不同的序列特征（比如事件类型），选用不同的序列
    func creatSingleObservable() {
        getSingle("ReactiveX/RxSwift").subscribe(onSuccess: { json in
            print("JSON: ", json)
        }, onError: { error in
            print("Error: ", error)
        })
            .disposed(by: disposeBag)
    }
    
    //Single：产生一个success或者产生一个 error 事件。适合HTTP 请求，然后返回一个response或错误
    func getSingle(_ repo: String) -> Single<[String: Any]> {
        return Single<[String: Any]>.create { singleObserver in
            let url = URL(string: "https://api.github.com/repos")!
            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                if let error = error {
                    singleObserver(.error(error))
                    return
                }
                guard let data = data,let json = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves),let result = json as? [String: Any] else {
                    singleObserver(.error(error!))
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
    func creatCompletableObservable() {
        getCompletable().subscribe(onCompleted: {
            print("Completed with no error")
        }, onError: { error in
            print("Completed with an error: \(error.localizedDescription)")
        })
            .disposed(by: disposeBag)
    }
    func getCompletable() -> Completable {
        return Completable.create { completableObserver in
            completableObserver(.completed)
            return Disposables.create {}
        }
    }
    
    //Maybe：只能发出一个元素，产生一个 completed 事件或者产生一个 error 事件
    func creatMaybeObservable() {
        let block = { (str: String) -> Void in
            print("Completed with element \(str)")
        }
        
        getMaybe().subscribe(onSuccess: block, onError: { error in
            print("Completed with an error \(error.localizedDescription)")
        }, onCompleted: {
            print("Completed with no element")
        })
            .disposed(by: disposeBag)
    }
    
    func getMaybe() -> Maybe<String> {
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
    func creatDriverObservable() {
        let result = textField.rx.text.orEmpty.asDriver().flatMap {
            return dealwithData(inputText: $0).asDriver(onErrorJustReturn: "检测到了错误事件")
        }.map{ $0 as! String} //把Any转为String
        
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
        result.drive(self.button.rx.title())//给Btn赋值，模拟更新UI
    }
    
    //MARK:订阅方法
    //subscribe对应的观察者有next/complete/error事件。bind对应的观察者只有next事件
    func bind() {
        
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
        let observable = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
//        observable
//            .map { "当前索引数：\($0 )"}
//            .bind(to: observer)
//            .disposed(by: disposeBag)

        observable
            .map { "当前索引数：\($0 )"}
            .do(onNext: { (text) in
                print("do(onNext\(text)")
            }, afterNext: { (text) in
                print("do(afterNext\(text)")
            }, onError: nil, afterError: nil, onCompleted: nil, afterCompleted: nil, onSubscribe: nil, onSubscribed: nil, onDispose: nil)
            .bind(to: observer)
            .disposed(by: disposeBag)

        
        // 把UITextField里的文字赋值给UIButton(把被观察者的值赋值给观察者)
        // button的rx.title属性为ControlProperty类型，所以不仅是观察者类型，还是被观察者类型
        textField.rx.text.bind(to: self.button.rx.title(for: .normal)) // 这样文本框输入的内容就会自动设置成按钮的标题了。
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
        let subject = BehaviorRelay<String>(value: "111")
        
        //修改value值
        subject.accept("222")
        
        //第1次订阅
        subject.asObservable().subscribe {
            print("第1次订阅：", $0)
        }.disposed(by: disposeBag)
        
        //修改value值
        subject.accept("333")
        
        //第2次订阅
        subject.asObservable().subscribe {
            print("第2次订阅：", $0)
        }.disposed(by: disposeBag)
        
        //修改value值
        subject.accept("444")
    }
    
    func creatControlProperty() {
        /*
         
         ControlProperty 专门用于描述 UI 控件属性的，它具有以下特征：
         
         不会产生 error 事件
         一定在 MainScheduler 订阅（主线程订阅）
         一定在 MainScheduler 监听（主线程监听）
         共享附加作用
         
         */
    }
    
    //MARK:操作符
    //操作符是序列的方法，也就是针对序列使用的。使用操作符将原有的序列转化为一个你想要的新的序列，可以帮助大家创建新的序列，或者变化组合原有的序列，从而生成一个新的序列。
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
    
    //MARK:调度器Schedulers
    //Schedulers 是 Rx 实现多线程的核心模块，它主要用于控制任务在哪个线程或队列运行。
    func schedulers() {
        //使用GCD
        // 后台取得数据，主线程处理结果
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
            }
        }
        
        let rxData: Observable<Data> = Observable.create { (observer) -> Disposable in
            return Disposables.create ()
        }
        
        /*
         subscribeOn:决定数据序列的构建函数在哪个 Scheduler 上运行。以下例子使用 subscribeOn 切换到 后台 Scheduler 来获取 Data
         observeOn：来决定在哪个 Scheduler 监听这个数据序列。以下例子中使用 observeOn 方法切换到主线程来监听并且处理结果。
         
         一个比较典型的例子就是，在后台发起网络请求，然后解析数据，最后在主线程刷新页面。你就可以先用 subscribeOn 切到后台去发送请求并解析数据，最后用 observeOn 切换到主线程更新页面。
         
         MainScheduler 代表主线程。如果你需要执行一些和 UI 相关的任务，就需要切换到该 Scheduler 运行。
         SerialDispatchQueueScheduler：抽象了串行 DispatchQueue。如果你需要执行一些串行任务，可以切换到这个 Scheduler 运行。
         ConcurrentDispatchQueueScheduler：抽象了并行 DispatchQueue。如果你需要执行一些并发任务，可以切换到这个 Scheduler 运行。
         OperationQueueScheduler：抽象了 NSOperationQueue。它具备 NSOperationQueue 的一些特点，例如，你可以通过设置 maxConcurrentOperationCount，来控制同时执行并发任务的最大数量。
         */
        rxData.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated)).observeOn(MainScheduler.instance).subscribe(onNext: { data in
        }).disposed(by: disposeBag)
    }
    
    //MARK:错误处理Error Handling
    func errorHandling() {
        /*一旦序列里面产出了一个 error 事件，整个序列将被终止。RxSwift 主要有两种错误处理机制：
         retry - 重试
         catch - 恢复
         */
        
        //请求 JSON 失败时，立即重试，重试 3 次后仍然失败，就将错误抛出
        let rxData: Observable<Data> = Observable.create { (observer) -> Disposable in
            return Disposables.create()
        }
        rxData.retry(3).subscribe(onNext: { data in
            print("取得 data 成功: \(data)")
        }, onError: { error in
            print("取得 data 失败: \(error)")
        })
            .disposed(by: disposeBag)
        
        //retryWhen：如果我们需要在发生错误时，经过一段延时后重试
        // 请求 JSON 失败时，等待 5 秒后重试，
        // 重试 4 次后仍然失败，就将错误抛出。
        let maxRetryCount = 4       // 最多重试 4 次
        let retryDelay: Double = 5  // 重试延时 5 秒
        rxData.retryWhen { (rxError: Observable<Error>) -> Observable<Int> in
            return rxError.flatMapWithIndex { (error, index) -> Observable<Int> in
                guard index < maxRetryCount else {
                    return Observable.error(error)
                }
                return Observable<Int>.timer(retryDelay, scheduler: MainScheduler.instance)
            }
        }
        .subscribe(onNext: { data in
            print("取得 data 成功: \(data)")
        }, onError: { error in
            print("取得 data 失败: \(error)")
        })
            .disposed(by: disposeBag)
        
        //使用 catchError，当错误产生时，将错误事件替换成一个备选序列：
        // 先从网络获取数据，如果获取失败了，就从本地缓存获取数据
        // 之前本地缓存的数据
        let cahcedData: Observable<Data> = Observable.create { (observer) -> Disposable in
            return Disposables.create()
        }
        
        rxData.catchError { error in cahcedData }.subscribe(onNext: { date in
            print("获取数据成功: \(date.count)")
        })
            .disposed(by: disposeBag)
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
    
    //MARK:替代传统的事件传递
    func local() {
        
        // button 点击事件
        // 第一种
        button.rx.tap.subscribe(onNext: {
            print("button Tapped")
        }).disposed(by: disposeBag)
        
        // 第二种
        button.rx.controlEvent(UIControl.Event.touchUpInside).subscribe(onNext: { [unowned self] in
            print(self)
        })
        
        // 代理
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
        
        //闭包回调
        let request = URLRequest(url: NSURL.init(fileURLWithPath: "") as URL)
        URLSession.shared.rx.data(request: request)
            .subscribe(onNext: { data in
                print("Data Task Success with count: \(data.count)")
            }, onError: { error in
                print("Data Task Error: \(error)")
            })
            .disposed(by: disposeBag)
        
        
        //通知
        // 发送通知
        NotificationCenter.default.post(name: Notification.Name(rawValue: "kNotificationTestName"), object: "testContent")
        // 接收通知，.takeUntil(self.rx.deallocated).作用是：保证页面销毁的时候移除通知
        NotificationCenter.default.rx.notification(Notification.Name("kNotificationTestName")).takeUntil(self.rx.deallocated).subscribe(onNext: { notification in
            print(notification)
        })
        
        
        //KVO
        //  不能用observe 否则会引起循环引用
        self.rx.observeWeakly(String.self, "nameStr").subscribe(onNext: { (value) in
            print(value ?? "")
        })
        
        // CGRect等类型不能用observeWeakly，否则监听不到
        textField.rx.observe(CGRect.self, "frame").subscribe(onNext: { (value) in
            print("frame = \(String(describing: value))")
        })
    }
    
    
    //MARK:常用例子
    func other() {
        
        
        //多个任务之间有依赖关系
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
}
