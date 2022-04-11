//
//  TableViewHeightCell.swift
//  SwiftProject
//
//  Created by Ryan on 2020/10/15.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class TableViewHeightCell: UITableViewCell {

    let label = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        //关闭点击效果
        self.selectionStyle = .none

        label.text = "Pano"
        label.backgroundColor = .red
        self.contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        let tap = UITapGestureRecognizer(target: self, action: #selector(tap))
        tap.delegate = self
        self.contentView.addGestureRecognizer(tap)

        let pan = UIPanGestureRecognizer(target: self, action: #selector(pan))
        pan.delegate = self
        self.contentView.addGestureRecognizer(pan)
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        print("event-3-hitTest")
        return super.hitTest(point, with: event)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("event-3-touchesBegan")
        super.touchesBegan(touches, with: event)
    }

    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        print("event-3-gestureRecognizerShouldBegin")
        return super.gestureRecognizerShouldBegin(gestureRecognizer)
    }

    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive event: UIEvent) -> Bool {
        print("event-3-shouldReceive")
        return true
    }

    @objc
    func tap() {
        print("event-3-tap")
    }

    @objc
    func pan() {
        print("event-3-pan")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
//        print("testSelected: selected: \(selected), \(self.label.text)")
        setColorState(selected)
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
//        print("testSelected: highlighted: \(highlighted), \(self.label.text)")
        setColorState(highlighted)
    }

    func setColorState(_ isState: Bool) {
        if isState {
            self.contentView.backgroundColor = .green
        } else {
            self.contentView.backgroundColor = .white
        }
    }
}
