//
//  GCDViewController.swift
//  SwiftProject
//
//  Created by ryan on 2020/1/19.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class GCDViewController: BaseViewController {
    private var rwlock = pthread_rwlock_t()
    private var array = [Int]() //初始化器语法
    private let semaphoreSignal = DispatchSemaphore(value: 1)//创建一个信号量，初始值为1

    deinit {
        pthread_rwlock_destroy(&rwlock)//释放读写锁
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        pthread_rwlock_init(&rwlock, nil)//初始化一个读写锁
//        test()
    }

    func test() {
        //thread A
        for i in 0...10_000 {
            DispatchQueue.global().async {
                //pthread_rwlock_trywrlock(&self.rwlock)
                pthread_rwlock_wrlock(&self.rwlock)
                if (i % 2 == 0) {
                    self.array = [1, 2, 3]
                }
                else {
                    self.array = [1]
                }
                print("Thread A: \(self.array)\n")
                pthread_rwlock_unlock(&self.rwlock)
            }
        }

        //thread B
        DispatchQueue.global().async {
            //pthread_rwlock_tryrdlock(&self.rwlock)
            pthread_rwlock_rdlock(&self.rwlock)
            for _ in 0...10_000 {
                if (self.array.count >= 2) {
                    _ = self.array[1]
                }
            }
            pthread_rwlock_unlock(&self.rwlock)
        }
    }

    func test1() {
        //thread A
        DispatchQueue.global().async {
            //pthread_rwlock_trywrlock(&self.rwlock)
            pthread_rwlock_wrlock(&self.rwlock)
            for i in 0...10_000 {
                if (i % 2 == 0) {
                    self.array = [1, 2, 3]
                }
                else {
                    self.array = [1]
                }
                print("Thread A: \(self.array)\n")
            }
            pthread_rwlock_unlock(&self.rwlock)
        }

        //thread B
        DispatchQueue.global().async {
            //pthread_rwlock_tryrdlock(&self.rwlock)
            pthread_rwlock_rdlock(&self.rwlock)
            for _ in 0...10_000 {
                if (self.array.count >= 2) {
                    _ = self.array[1]
                }
            }
            pthread_rwlock_unlock(&self.rwlock)
        }
    }

    func old() {
        let queue1 = DispatchQueue(label: "queue1", qos: .utility) // 默认串行
        let queue2 = DispatchQueue(label: "queue1", qos: .utility, attributes: .concurrent)
        let queue3 = DispatchQueue(label: "queue13", qos: .utility,
        attributes: .initiallyInactive) //需要程序员去手动触发

        queue1.async {
            for i in 5..<10 {
                print(i)
            }
        }

        //需要调用activate，激活队列。
        queue3.activate()
    }
}
