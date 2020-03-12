//
//  BPCellViewModel.swift
//  SwiftProject
//
//  Created by ryan on 2020/1/15.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class BPLabelViewModel: NSObject, BPCellViewModelProtocol {


    let model: BPLabelModel?
    var title: String?

    static func canHandle(type: String) -> Bool {
        if type == "label" {
            return true
        }
        return false
    }

    required init(data: BPModel) {
        self.model = data.label
        self.title = self.model?.title
    }

    var res: String {
        return "BPLabelTableViewCell"
    }
}

class BPImageViewModel: NSObject, BPCellViewModelProtocol {

    let model: BPImageModel?
    var imageUrl: String?

    static func canHandle(type: String) -> Bool {
        if type == "image" {
            return true
        }
        return false
    }

    required init(data: BPModel) {
        self.model = data.image
        self.imageUrl = self.model?.imageUrl
    }

    var res: String {
        return "BPImageTableViewCell"
    }
}

class BPButtonViewModel: NSObject, BPCellViewModelProtocol {

    let model: BPButtonModel?
    var jump: String?

    static func canHandle(type: String) -> Bool {
        if type == "button" {
            return true
        }
        return false
    }

    required init(data: BPModel) {
        self.model = data.button
        self.jump = self.model?.jump
    }

    var res: String {
        return "BPButtonTableViewCell"
    }
}
