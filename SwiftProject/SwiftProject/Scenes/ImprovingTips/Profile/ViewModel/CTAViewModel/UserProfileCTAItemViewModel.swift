//
//  UserProfileCTAItemViewModel.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/19.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

protocol UserProfileCTAItemViewModelProtocol {
    static func canHandle(type: Int) -> Bool
    init(ctaItem: [String: Any])
    var title: String?{set get}
    var imageUrl: String?{set get}
    var viewType: String{get}
    func didClick()
}

extension UserProfileCTAItemViewModelProtocol {
    static func canHandle(type: Int) -> Bool {return false}
    //init(ctaItem: [String: Any]){self.init(ctaItem: [String: Any])}
    var title: String? { set{} get{return nil} }
    var imageUrl: String? { set{} get{return nil} }
    var viewType: String {get{return "UserProfileCTAItemView"} }
    func didClick(){}
}

//发消息
class UserProfileCTAChatViewModel: NSObject, UserProfileCTAItemViewModelProtocol {

    var chat: CTAOpenChatItem?
    var title: String?
    var imageUrl: String?

    static func canHandle(type: Int) -> Bool {
        if type == 2 {
            return true
        }
        return false
    }

    required init(ctaItem: [String: Any]) {
        super.init()
        self.chat = CTAOpenChatItem.deserialize(from: ctaItem)
        self.title = self.chat?.key
        self.imageUrl = ""
    }

    func didClick() {

    }
}

//手机/语音
class UserProfileCTAPhoneViewModel: NSObject, UserProfileCTAItemViewModelProtocol {

    var phone: CTAPhoneItem?
    var title: String?
    var imageUrl: String?

    static func canHandle(type: Int) -> Bool {
        if type == 3 {
            return true
        }
        return false
    }

    required init(ctaItem: [String: Any]) {
        super.init()
        self.phone = CTAPhoneItem.deserialize(from: ctaItem)
        self.title = self.phone?.key
        self.imageUrl = ""
    }

    func didClick() {

    }
}

// 视频
class UserProfileCTAIVideoViewModel: NSObject, UserProfileCTAItemViewModelProtocol {

    var video: CTAVideoItem?
    var title: String?
    var imageUrl: String?

    static func canHandle(type: Int) -> Bool {
        if type == 4 {
            return true
        }
        return false
    }

    required init(ctaItem: [String: Any]) {
        super.init()
        self.video = CTAVideoItem.deserialize(from: ctaItem)
        self.title = self.video?.key
        self.imageUrl = ""
    }

    func didClick() {

    }
}

//密聊
class UserProfileCTAISecretChatViewModel: NSObject, UserProfileCTAItemViewModelProtocol {

    var secretChat: CTASecretChatItem?
    var title: String?
    var imageUrl: String?

    static func canHandle(type: Int) -> Bool {
        if type == 5 {
            return true
        }
        return false
    }

    required init(ctaItem: [String: Any]) {
        super.init()
        self.secretChat = CTASecretChatItem.deserialize(from: ctaItem)
        self.title = self.secretChat?.key
        self.imageUrl = ""
    }

    func didClick() {

    }
}

//link
class UserProfileCTALinkViewModel: NSObject, UserProfileCTAItemViewModelProtocol {

    var linkItem: CTALinkItem?
    var title: String?
    var imageUrl: String?

    static func canHandle(type: Int) -> Bool {
        if type == 1 {
            return true
        }
        return false
    }

    required init(ctaItem: [String: Any]) {
        super.init()
        self.linkItem = CTALinkItem.deserialize(from: ctaItem)
        self.title = self.linkItem?.key
        self.imageUrl = ""
    }

    func didClick() {

    }
}

//更多
class UserProfileCTAMoreViewModel: NSObject, UserProfileCTAItemViewModelProtocol {
    var array: [UserProfileCTAItemViewModelProtocol]?
    var title: String?
    var imageUrl: String?

    static func canHandle(type: Int) -> Bool {
        return true
    }

    required init(ctaItem: [String: Any]) {
        super.init()
        self.title = "更多"
        self.imageUrl = ""
    }

    required init(ctaItems: [UserProfileCTAItemViewModelProtocol]) {
        super.init()
        self.title = "更多"
        self.imageUrl = ""
    }


    func didClick() {
        guard let array = array, array.count <= 0 else {
            return
        }

        let alert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        for viewModel in array {
            let action = UIAlertAction(title: viewModel.title, style: .default, handler: {
                action in
                viewModel.didClick()
            })
            alert.addAction(action)
        }

        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        //self.present(alert, animated: true, completion: nil)
    }
}
