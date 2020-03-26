//
//  UserProfileCTAItemViewModel.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/19.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

protocol UserProfileCTAItemViewModelProtocol {
    static func canHandle(type: String) -> Bool
    init(ctaInfo: CTAInfo)
    var title: String?{set get}
    var imageUrl: String?{set get}
    var viewType: String{get}
    func didClick()
}

extension UserProfileCTAItemViewModelProtocol {
    static func canHandle(type: String) -> Bool {return false}
    init(ctaInfo: CTAInfo){self.init(ctaInfo: ctaInfo)}
    var title: String? { set{} get{return nil} }
    var imageUrl: String? { set{} get{return nil} }
    var viewType: String {get{return "UserProfileCTAItemView"} }
    func didClick(){}
}

//更多
class UserProfileCTAMoreViewModel: NSObject, UserProfileCTAItemViewModelProtocol {

    var array: [UserProfileCTAItemViewModelProtocol]?
    var title: String?
    var imageUrl: String?

    static func canHandle(type: String) -> Bool {
        if type == "more" {
            return true
        }
        return false
    }

    required init(ctaInfo: CTAInfo) {
        super.init()
        self.title = "更多"
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
//        self.present(alert, animated: true, completion: nil)
    }
}

//发消息
class UserProfileCTAIChatViewModel: NSObject, UserProfileCTAItemViewModelProtocol {

    var chat: CTAOpenChatItem?
    var title: String?
    var imageUrl: String?

    static func canHandle(type: String) -> Bool {
        if type == "chat" {
            return true
        }
        return false
    }

    required init(ctaInfo: CTAInfo) {
        super.init()
        self.chat = ctaInfo.chat
        self.title = self.chat?.key
    }

    func didClick() {

    }
}

// 视频
class UserProfileCTAIVideoViewModel: NSObject, UserProfileCTAItemViewModelProtocol {

    var video: CTAVideoItem?
    var title: String?
    var imageUrl: String?

    static func canHandle(type: String) -> Bool {
        if type == "video" {
            return true
        }
        return false
    }

    required init(ctaInfo: CTAInfo) {
        super.init()
        self.video = ctaInfo.video
        self.title = self.video?.key
    }

    func didClick() {

    }
}

// 视频
class UserProfileCTAIVoiceViewModel: NSObject, UserProfileCTAItemViewModelProtocol {

    var video: CTAVideoItem?
    var title: String?
    var imageUrl: String?

    static func canHandle(type: String) -> Bool {
        if type == "voice" {
            return true
        }
        return false
    }

    required init(ctaInfo: CTAInfo) {
        super.init()
        self.video = ctaInfo.video
        self.title = "语音"
    }

    func didClick() {

    }
}

//密聊
class UserProfileCTAISecretChatViewModel: NSObject, UserProfileCTAItemViewModelProtocol {

    var secretChat: CTASecretChatItem?
    var title: String?
    var imageUrl: String?

    static func canHandle(type: String) -> Bool {
        if type == "secretChat" {
            return true
        }
        return false
    }

    required init(ctaInfo: CTAInfo) {
        super.init()
        self.secretChat = ctaInfo.secretChat
        self.title = self.secretChat?.key
    }

    func didClick() {

    }
}

//手机
class UserProfileCTAPhoneViewModel: NSObject, UserProfileCTAItemViewModelProtocol {

    var phone: CTAPhoneItem?
    var title: String?
    var imageUrl: String?

    static func canHandle(type: String) -> Bool {
        if type == "phone" {
            return true
        }
        return false
    }

    required init(ctaInfo: CTAInfo) {
        super.init()
        self.phone = ctaInfo.phone
        self.title = self.phone?.key
    }

    func didClick() {

    }
}

//link
class UserProfileCTALinkViewModel: NSObject, UserProfileCTAItemViewModelProtocol {

    var linkItems: [CTALinkItem]?
    var title: String?
    var imageUrl: String?

    static func canHandle(type: String) -> Bool {
        if type == "link" {
            return true
        }
        return false
    }

    required init(ctaInfo: CTAInfo) {
        super.init()
        self.linkItems = ctaInfo.linkItems
    }

    func didClick() {

    }
}
