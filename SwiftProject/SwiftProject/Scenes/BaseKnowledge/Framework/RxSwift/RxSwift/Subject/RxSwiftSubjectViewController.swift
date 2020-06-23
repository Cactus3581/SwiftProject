//
//  RxSwiftSubjectViewController.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2020/4/18.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RxSwiftSubjectViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        publishRelay()

    }

    //MARK: - PublishRelay
    func publishRelay() {
        let disposeBag = DisposeBag()
        let relay = PublishRelay<String>()

        relay
            .subscribe { print("Event:", $0) }
            .disposed(by: disposeBag)

        relay.accept("🐶")
        relay.accept("🐱")

        /*
        输出结果：
        Event: next(🐶)
        Event: next(🐱)
         */
    }


}
