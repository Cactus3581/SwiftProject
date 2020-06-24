//
//  MenuTextView.swift
//  SwiftProject
//
//  Created by Ryan on 2020/4/7.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit



class MenuTextView: UITextView {

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    func setup() {
        let copyItem = UIMenuItem.init(title: "复制", action: #selector(copyClick))
        UIMenuController.shared.menuItems = [copyItem]
        UIMenuController.shared.isMenuVisible = true
        UIMenuController.shared.showMenu(from: self, rect: self.bounds)
        addObserver(self, forKeyPath: "selectedTextRange", options: [.new], context:nil)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "selectedTextRange" {
            print(self.selectedRange,self.selectedTextRange)
        }
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if (action == #selector(copyClick)) {
            return true
        }
        return false
    }

    @objc func copyClick() {
        UIMenuController.shared.setMenuVisible(false, animated: true)
        self.resignFirstResponder()

        // 方法1
//        guard let range = Range(self.selectedRange, in: self.text), let str = String(self.text[range]) else { return }
//        print(str)

        // 方法2
        guard let selectedTextRange = self.selectedTextRange, let str1 = self.text(in: selectedTextRange) else {
            print(self.text)
            return
        }
        print(str1)
    }

    override func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        super.pressesEnded(presses, with: event)
        print("end")
    }

}

extension MenuTextView {

    //selectedTextRange -> NSRange
    func p_getSelectedRange() -> NSRange? {
        // 内容为[start,end)，无论是否有选取区域，start都描述了光标的位置
        if let selectedTextRange = self.selectedTextRange {
            //let caretRect = self.caretRect(for: selectedTextRange.start)
            //self.scrollRectToVisible(caretRect, animated: false)

            let selectionStart = selectedTextRange.start
            let selectionEnd = selectedTextRange.end
            // 获取以from为基准的to的偏移
            let location = self.offset(from: self.beginningOfDocument, to: selectionStart)
            let length = self.offset(from: selectionStart, to: selectionEnd)
            return NSMakeRange(location, length)
        }
        return nil

        //文本字段文本的开头：
        let startPosition: UITextPosition = self.beginningOfDocument
        //文本字段文本的最后：
        let endPosition: UITextPosition = self.endOfDocument
        //当前选择的范围：
        let selectedRange: UITextRange? = self.selectedTextRange

        //获取光标位置
        if let selectedRange = self.selectedTextRange {
            let cursorPosition = self.offset(from: self.beginningOfDocument, to: selectedRange.start)
        }
    }
    //设置光标选中范围
    func p_setSelectedRange(range: NSRange) {
        // 备注：UITextField必须为第一响应者才有效
        let beginning = self.beginningOfDocument
        guard let startPosition =  self.position(from: beginning, offset: range.location) else { return }
        guard let endPosition = self.position(from: beginning, offset: range.location + range.length) else { return }
        // 创建一个UITextRange
        let selectionTextRange = self.textRange(from: startPosition, to: endPosition)
        self.selectedTextRange = selectionTextRange//设置光标选中范围
    }
}

extension MenuTextView {
    override func beginFloatingCursor(at point: CGPoint) {
        print("beginFloatingCursor\(point)")
    }

    override func updateFloatingCursor(at point: CGPoint) {
        print("endFloatingCursor\(point)")
    }

    override func endFloatingCursor() {
        print("endFloatingCursor")
    }
}

