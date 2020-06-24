//
//  RxSchedulerViewController.swift
//  SwiftProject
//
//  Created by Ryan on 2020/6/23.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RxSchedulerViewController: BaseViewController {
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

}
