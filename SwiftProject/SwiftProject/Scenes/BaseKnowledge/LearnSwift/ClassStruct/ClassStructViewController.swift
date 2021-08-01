//
//  ClassStructViewController.swift
//  SwiftProject
//
//  Created by ryan on 2020/1/2.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class ClassStructViewController: BaseViewController {

    var structTotalModel = StructTotalModel()
    var structTotalModel1 = StructTotalModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        let item = UIBarButtonItem(title:"show",
                                   style:.plain,
                                   target:self,
                                   action:#selector(click10))
        self.navigationItem.rightBarButtonItem = item
        self.structTotalModel1 = structTotalModel
        
        let label1 = UILabel()
        label1.text = "dakdoa"
        label1.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        self.view.addSubview(label1)
        label1.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
        }
        
        let label2 = UILabel()
        label2.text = "都撒到"
        self.view.addSubview(label2)
        label2.setContentCompressionResistancePriority(.required, for: .horizontal)
        label2.snp.makeConstraints { make in
            make.leading.equalTo(label1.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
            make.trailing.lessThanOrEqualToSuperview().offset(-10)
        }
    }
    
//---------------
    @objc
    func click11() {
        var b = StructTotalModel() {
            didSet {
                print("didSet: \(b.total), \(b.list1)")
            }
        }
        
        b.list1 = [1]
        
        // 以下两个case说明，在只读的情况下，使用或者不使用copy，读的都是原始变量指向的最新值
        DispatchQueue.main.async {
            var a = b
            print("main-3-1: \(a.list1)")
            sleep(2)
            print("main-3-2: \(a.list1)")
        }
        
        DispatchQueue.main.async {
            print("main-4: \(b.list1)")
        }
        
        DispatchQueue.global().async {
            b.total = "3"
            b.list1.removeLast()
            print("global-5: \(b.list1)")
        }
    }
    @objc
    func click10() {
        var b = StructTotalModel() {
            didSet {
                print("didSet: \(b.total), \(b.list1)")
            }
        }
        
        // 这个case说明先copy，再改写不会影响原来的值
        DispatchQueue.global().async {
            var a = b
            a.total = "1"
            a.list1 = [1]
            print("global-1: \(a.total), \(a.list1)")
        }
        
        // 这个case说明不使用copy，直接改写会影响原来的值
        DispatchQueue.global().async {
            b.total = "2"
            b.list1.append(2)
            print("global-2: \(b.total), \(b.list1)")
        }
        
        // 以下两个case说明，在只读的情况下，使用或者不使用copy，读的都是原始变量指向的最新值
        DispatchQueue.main.async {
            var a = b
            print("main-3-1: \(a.total), \(a.list1)")
            sleep(2)
            print("main-3-2: \(a.total), \(a.list1)")
        }
        
        DispatchQueue.main.async {
            print("main-4: \(b.total), \(b.list1)")
        }
        
        DispatchQueue.global().async {
            b.total = "3"
            b.list1.removeLast()
            print("global-5: \(b.total), \(b.list1)")
        }
    }
//---------------
    
    @objc
    func click1() {
        //测试：修改最底层模型的普通变量
        
        // 方法1:直接修改，结果报错: Cannot assign to property: 'first' is a get-only property
        // self.structTotalModel.list.first?.list.first?.chat = "click1"
        
        // 方法2:copy下修改，结果原来的模型没有修改成功
        var chat = self.structTotalModel.list.first?.list.first
        chat?.chat = "click1"
        print(self.structTotalModel.list.first?.list.first?.chat)
        
        // 方法3:一层一层的修改。使用外面赋值也好，还是内部使用mutaing也好，都得一层一层的修改
        var teamModels = self.structTotalModel.list
        var firstTeam = teamModels.first
        var chatModels = firstTeam?.list
        chatModels?[0] = chat!
        firstTeam?.list = chatModels!
        teamModels[0] = firstTeam!
        self.structTotalModel.list = teamModels
        print(self.structTotalModel.list.first?.list.first?.chat)

        self.structTotalModel.updateChat(chat: chat!)
        print(self.structTotalModel.list.first?.list.first?.chat)
    }
    
    @objc
    func click2() {
        var chat = StructChatModel()
        chat.chat = "a"
        var list = [chat]
        chat.chat = "b"
        print(list.first?.chat)
    }
    
    @objc
    func click3() {
        self.structTotalModel.total = "a"
        print(structTotalModel1.total)
    }
    
    @objc
    func click4() {
        self.structTotalModel.total = "a"
        print(structTotalModel1.total)
    }
}
