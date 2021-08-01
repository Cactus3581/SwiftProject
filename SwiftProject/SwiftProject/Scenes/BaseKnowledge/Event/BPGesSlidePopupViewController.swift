//
//  BPGesSlidePopupViewController.swift
//  SwiftProject
//
//  Created by Ryan on 2021/5/31.
//  Copyright © 2021 cactus. All rights reserved.
//

import UIKit
import SnapKit

class BPGesSlidePopupViewController: BaseViewController, BPGesSlidePopupViewDelegate {

    private var dataSource = ["1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1"]

    private weak var popupView: BPGesSlidePopupViewProtocol?
    private weak var contentView: BPGesSlidePopupContentView?

    override func viewDidLoad() {
        super.viewDidLoad()
        let item = UIBarButtonItem(title:"show",
                                                 style:.plain,
                                                 target:self,
                                                 action:#selector(showGesSlidePopupView))
        self.navigationItem.rightBarButtonItem = item
    }

    @objc
    func showGesSlidePopupView() {
        let contentView = BPGesSlidePopupContentView(frame: .zero, dataSource: dataSource)
        self.contentView = contentView

        let popupView = BPGesSlidePopupView.showInView(parentView: self.view, contentView: contentView, delegate: self)
        self.popupView = popupView
    }

    func updateData() {
        self.contentView?.updateData(dataSource)
    }

    func popupViewShowFinished(_ popupView: BPGesSlidePopupView) {}

    func popupView(_ popupView: BPGesSlidePopupView, width: CGFloat) -> CGFloat {
        guard !self.dataSource.isEmpty else {
            return 150
        }
        let width1 = Int(width)
        let perLineCount: Int = (width1 - 10 - 10 + 10) / (100 + 10)
        var line: Int = self.dataSource.count / perLineCount
        let isAddline:Int = self.dataSource.count % perLineCount
        if (isAddline != 0) {
            line += 1
        }
        let height = line * 100 + 10 + 10 + (line - 1) * 20
        return CGFloat(height + 80)
    }
}
