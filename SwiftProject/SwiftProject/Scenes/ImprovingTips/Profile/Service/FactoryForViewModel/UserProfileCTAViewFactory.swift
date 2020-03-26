//
//  UserProfileCTAViewFactory.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2020/3/25.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class UserProfileCTAViewFactory: NSObject {

    static var ctaViews: [UserProfileCTAItemViewProtocol.Type] = []

    static func registerCtaView(view: UserProfileCTAItemViewProtocol.Type) {
        if !UserProfileCTAViewFactory.ctaViews.contains(where: { $0 == view }) {
            UserProfileCTAViewFactory.ctaViews.append(view)
        }
    }

    static func viewWithType(type: String) -> UserProfileCTAItemViewProtocol? {
        guard let ctaItemViewClass =  getClass(type: type) else {
            return nil
        }
        let view = ctaItemViewClass.init()
        return view 
    }

    static func getClass(type: String) -> UserProfileCTAItemViewProtocol.Type? {
        for tClass in UserProfileCTAViewFactory.ctaViews {
            if tClass.canHandle(type: type) {
                return tClass
            }
        }
        return nil
    }
}
