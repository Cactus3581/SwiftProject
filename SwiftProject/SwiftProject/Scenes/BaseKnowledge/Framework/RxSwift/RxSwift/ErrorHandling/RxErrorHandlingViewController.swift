//
//  RxErrorHandlingViewController.swift
//  SwiftProject
//
//  Created by Ryan on 2020/6/23.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RxErrorHandlingViewController: BaseViewController {
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

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

}
