//
//  BPGesSlidePopupView.swift
//  SwiftProject
//
//  Created by Ryan on 2021/6/3.
//  Copyright © 2021 cactus. All rights reserved.
//

import UIKit

protocol BPGesSlidePopupViewDelegate: NSObjectProtocol {
    func popupViewShowFinished(_ popupView: BPGesSlidePopupView)
    func popupView(_ popupView: BPGesSlidePopupView, width: CGFloat) -> CGFloat
}

// #pragma mark - 对外提供的接口
protocol BPGesSlidePopupViewProtocol: UIView {
    static func showInView(parentView: UIView, contentView: UIView, delegate: BPGesSlidePopupViewDelegate) -> BPGesSlidePopupViewProtocol

    func show(isNeedCallBack: Bool)

    func dismiss()

    func reload()
}

class BPGesSlidePopupView: UIView, UIGestureRecognizerDelegate, BPGesSlidePopupViewProtocol {

    private let contentView: UIView
    private weak var scrollView: UIScrollView?
    private lazy var tapGesture: UITapGestureRecognizer = {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        return tapGesture
    }()
    private lazy var panGesture: UIPanGestureRecognizer = {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        return panGesture
    }()
    private weak var delegate: BPGesSlidePopupViewDelegate?

    static func showInView(parentView: UIView, contentView: UIView, delegate: BPGesSlidePopupViewDelegate) -> BPGesSlidePopupViewProtocol {
        let popupView = BPGesSlidePopupView(frame: parentView.bounds, contentView: contentView, delegate: delegate)
        parentView.addSubview(popupView)
        popupView.snp.makeConstraints { make in
            make.edges.equalTo(parentView)
        }
        popupView.layoutIfNeeded()
        popupView.updateContentViewY(popupView.frame.size.height)
        popupView.show(isNeedCallBack: true)
        return popupView
    }

    init(frame: CGRect, contentView: UIView, delegate: BPGesSlidePopupViewDelegate) {
        self.contentView = contentView
        self.delegate = delegate
        super.init(frame: frame)
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        contentView.layer.masksToBounds = true
        // 默认不展示内容视图
        self.addSubview(self.contentView)
        // 添加手势
        self.tapGesture.delegate = self
        self.addGestureRecognizer(self.tapGesture)
        self.panGesture.delegate = self
        self.addGestureRecognizer(self.panGesture)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has falset been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateContentViewSize()
        updateContentViewY(self.frame.size.height - self.contentView.frame.size.height)
    }

    // #pragma mark - 对外提供的接口
    func show(isNeedCallBack: Bool) {
        UIView.animate(withDuration: 0.25) {
            let y = self.frame.size.height - self.contentView.frame.size.height
            self.updateContentViewY(y)
            self.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        } completion: { finished in
            if isNeedCallBack {
                self.delegate?.popupViewShowFinished(self)
            }
        }
    }

    func dismiss() {
        UIView.animate(withDuration: 0.25) {
            self.updateContentViewY(self.frame.size.height)
            self.backgroundColor = UIColor.gray.withAlphaComponent(0)
        } completion: { finished in
            self.removeFromSuperview()
        }
    }

    func reload() {
        // 重新对contentView进行布局。常见case：当contentView的数据发生变化时，对height和y值进行刷新
        layoutSubviews()
    }

// #pragma mark - UIGestureRecognizerDelegate
    // 获取内部的scroll
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if gestureRecognizer == self.panGesture {
            var touchView = touch.view
            while (touchView != nil) {
                if let touchView1 = touchView as? UIScrollView {
                    self.scrollView = touchView1
                    return true
                }
                if let next = touchView?.next, let nextView = next as? UIView {
                    touchView = nextView
                } else {
                    touchView = nil
                }
            }
        }
        return true
    }

    // 控制手势事件传递
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if (gestureRecognizer == self.tapGesture) {
            let point = gestureRecognizer.location(in: contentView)
            if self.contentView.layer.contains(point) && gestureRecognizer.view == self {
                // 防止点到scroll区域
                return false
            }
        }else if (gestureRecognizer == self.panGesture) {
            return true
        }
        return true
    }

    // 是否允许两个手势同时存在
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let scrollView = self.scrollView else { return false }
        let result = (gestureRecognizer == self.panGesture) && (otherGestureRecognizer == scrollView.panGestureRecognizer)
        return result
    }

// #MARK - 手势回调事件
    @objc
    func handleTapGesture(tapGesture: UITapGestureRecognizer) {
        dismiss()
    }

    @objc
    func handlePanGesture(panGesture: UIPanGestureRecognizer) {
        let translation = panGesture.translation(in: contentView)
        let point = panGesture.location(in: scrollView)
        let isOperScrollView = scrollView?.layer.contains(point) ?? false
        if isOperScrollView {
            // 当手指在scrollView滑动时
            guard let scrollView = self.scrollView else { return }
            if scrollView.contentOffset.y <= 0 {
                // 当scrollView在最顶部时
                if (translation.y > 0) {
                    // 向下拖拽
                    changeScrollEnabled(false)
                    scrollView.contentOffset = .zero
                    let y = self.contentView.frame.origin.y + translation.y
                    updateContentViewY(y)
                }
            }
        }else {
            if (translation.y > 0) {
                // 向下拖拽
                let y = self.contentView.frame.origin.y + translation.y
                updateContentViewY(y)
            }else if (translation.y < 0) {
                // 向上拖拽
                let contentMinY = self.frame.size.height - self.contentView.frame.size.height
                let contentY = self.contentView.frame.origin.y
                if contentY > contentMinY {
                    let y = max(contentY + translation.y, contentMinY)
                    updateContentViewY(y)
                }
            }
        }

        if panGesture.state == .ended {
            changeScrollEnabled(true)
            // 手指离开屏幕时，进行展示/收起contentView
            showOrDismissWhenPanEnd()
        }

        // 复位
        panGesture.setTranslation(.zero, in: contentView)
    }

    // #pragma mark - 内部方法
    private func updateContentViewSize() {
        var contentFrame = self.contentView.frame
        contentFrame.size.width = self.frame.size.width
        guard let delegate = self.delegate else { return }
        let contentHeight = delegate.popupView(self, width: self.frame.size.width)
        let suppliedMaxHeight = self.frame.size.height - safeAreaHeight()
        contentFrame.size.height = min(contentHeight, suppliedMaxHeight)
        self.contentView.frame = contentFrame
    }

    private func safeAreaMinY() -> CGFloat {
        if #available(iOS 11.0, *) {
            return self.safeAreaInsets.top
        } else {
            return self.layoutMargins.top
        }
    }

    private func safeAreaHeight() -> CGFloat {
        if #available(iOS 11.0, *) {
            return self.safeAreaInsets.top + self.safeAreaInsets.bottom
        } else {
            return self.layoutMargins.top + self.layoutMargins.bottom
        }
    }

    private func updateContentViewY(_ y: CGFloat) {
        var contentFrame = self.contentView.frame
        // contentView不能高于容器
        let minY = safeAreaMinY()
        contentFrame.origin.y = max(y, minY)
        self.contentView.frame = contentFrame

        let criticalY = self.frame.size.height - self.contentView.frame.size.height
        let progress = 1 - (self.contentView.frame.origin.y - criticalY) / self.contentView.frame.size.height
        updateToProgress(progress)
    }

    private func updateToProgress(_ progress: CGFloat) {
        let alpha = 0.5 * progress
        self.backgroundColor = UIColor.gray.withAlphaComponent(alpha)
        contentView.layer.cornerRadius = progress * 6
    }

    private func changeScrollEnabled(_ enabled: Bool) {
        self.scrollView?.panGestureRecognizer.isEnabled = enabled
    }

    private func showOrDismissWhenPanEnd() {
        let criticalY = self.frame.size.height - self.contentView.frame.size.height/2
        if (self.contentView.frame.origin.y > criticalY) {
            dismiss()
        }else {
            show(isNeedCallBack: false)
        }
    }
}
