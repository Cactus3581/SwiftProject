//
//  OperatorViewController.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2020/6/3.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class OperatorViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        combineLatest()
//        zip()
        
    }
    
    //MARK: - combineLatest
    func combineLatest() {
        let disposeBag = DisposeBag()

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

         找最新的
         1A
         2A
         2B
         2C
         2D
         3D
         4D

         */
    }

    func zip() {
        let disposeBag = DisposeBag()
        let first = PublishSubject<String>()
        let second = PublishSubject<String>()

        Observable.zip(first, second) { $0 + $1 }
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

        first.onNext("5")

        /*

         1A
         2B
         3C
         4D

         */
    }
}
