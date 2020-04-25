//
//  RxSwiftExampleViewController.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2020/4/13.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

//位移枚举
 struct Status : OptionSet {
    let rawValue: Int
    static let normal = Status(rawValue: 1)
    static let searching = Status(rawValue: 2)
    static let filtering = Status(rawValue: 4)
}



class RxSwiftExampleViewController: BaseViewController {

    let disposeBag = DisposeBag()
    var status: Status = [.normal]

    override func viewDidLoad() {
        super.viewDidLoad()

        let vc = RxSwiftViewController()
        self.present(vc,animated:true,completion:nil)




//        print(status.contains(.normal))
//        print(status.contains(.searching))
//        print(status.contains(.filtering))
//        status = [.normal, .searching]
//        print(status.contains(.normal))
//        print(status.contains(.searching))
//        print(status.contains(.filtering))
        status = [.normal, .searching, .filtering]
//        print(status.contains(.normal))
//        print(status.contains(.searching))
//        print(status.contains(.filtering))


        //  交集
        let commonEvents = status.intersection(.filtering)
        print(commonEvents)

        print(commonEvents.contains(.normal))
        print(commonEvents.contains(.searching))
        print(commonEvents.contains(.filtering))


        fetchSubtitles().subscribe().disposed(by: disposeBag)
        dataObservable.subscribe(onNext: { (array) in
            print(array)
        }, onError: { (error) in
            print(error)
        }).disposed(by: disposeBag)
    }
    
    private let dataRelay = BehaviorRelay<[String]>(value: [""])
    var data: [String] {
        get {
            return dataRelay.value
        }
        
        set(newdata) {
            dataRelay.accept(newdata)
        }
    }
    
    // 供外面监听的序列
    var dataObservable: Observable<[String]> {
        return dataRelay.asObservable()
            .distinctUntilChanged()
    }
    
    func request() ->  Single<[String: Any]> {
        return Observable<[String: Any]>.create({ (ob) -> Disposable in
            //模拟网络请求
            DispatchQueue.global().async {
                print("模拟器请求")
                ob.onNext(["a":"A"])//数据返回
                ob.onCompleted()
            }
            return Disposables.create()
        }).asSingle()
    }
    
    func handleModel(response: [String: Any]) ->  Single<[String]> {
        return Observable<[String]>.create { (observer) -> Disposable in
            observer.onNext(["a"])
            observer.onCompleted()
            return Disposables.create ()
        }.asSingle()
    }

    //请求数据的例子
    // 主动拉取数据

    func fetchSubtitles() -> Completable {
        return Completable.deferred({ [weak self] in
            guard let self = self else {
                return .empty()
            }
            
            return self.request()
                .flatMap { [weak self] response -> Single<Any> in
                    guard let self = self else {
                        return .error(VCError.unknown)
                    }
                    
                    return self.handleModel(response: response)
                        .map({ array in
                            // 继续转数据，虽然这里用不到
                            return array
                        })
            }
            .do(onSuccess: {[weak self] array in
                self?.data = array as! [String]
                }, onError: nil)
                .asCompletable()
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

enum VCError: Error {
    case unknown // 未知错误
}
