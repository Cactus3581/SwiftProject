//
//  TextViewViewController.swift
//  SwiftProject
//
//  Created by Ryan on 2020/10/3.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class TextViewViewController: BaseViewController, UITextViewDelegate {

    let textView = UITextView()
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.backgroundColor = .lightText
        textView.delegate = self
        textView.text = ""
        textView.font = UIFont.systemFont(ofSize: 12)
        textView.textColor = .red
        textView.textAlignment = .left

        let range = NSRange(location: 0, length: 10)
        textView.selectedRange = range

        textView.isEditable = true
        textView.isSelectable = true

        textView.scrollRangeToVisible(range)

        textView.allowsEditingTextAttributes = false // defaults to NO
        textView.attributedText = NSAttributedString(string: "")

        // textView.typingAttributes = NSAttributedString(string: "")/ / automatically resets when the selection changes
        // textView.dataDetectorTypes =

        // Presented when object becomes first responder.  If set to nil, reverts to following responder chain.  If
        // set while first responder, will not take effect until reloadInputViews is called.
        textView.inputView = nil
        textView.inputAccessoryView = nil
        textView.clearsOnInsertion = false// defaults to NO. if YES, the selection UI is hidden, and inserting text will replace the contents of the field. changing the selection will automatically set this to NO.

        textView.becomeFirstResponder()
        view.addSubview(textView)
        textView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
            make.centerY.equalToSuperview()
            make.height.equalTo(50)
        }
    }

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        print("1-textViewShouldBeginEditing")
        return true
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        print("2-textViewDidBeginEditing")
    }

    // repeat start -----
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        print("3-replacementText")
        return true
    }

    func textViewDidChangeSelection(_ textView: UITextView) {
        print("4-textViewDidChangeSelection")
    }

    func textViewDidChange(_ textView: UITextView) {
        print("5-textViewDidChange")
    }

    // ----- repeat end
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        print("6-textViewShouldEndEditing")
        return true
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        print("7-textViewDidEndEditing")
    }

    // 点击url进行交互
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        print("characterRange1")
        return true
    }

    func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        print("characterRange2")
        return true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        textView.resignFirstResponder()
    }
}
