//
//  UserProfileCommonTableViewCell.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/19.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class UserProfileTextTableViewCell: UITableViewCell, UserProfileTableViewCellProtocol {

    weak var topicView: UserProfileTopicView!
    weak var titleLabel: UILabel!
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {

        let topicView = UserProfileTopicView()
        self.topicView = topicView

        let label = UILabel()
        self.titleLabel = label

        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = UIColor.white
        self.selectionStyle = .none

        self.contentView.addSubview(topicView)
        self.contentView.addSubview(label)

        topicView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }

        label.snp.makeConstraints {
            $0.leading.equalTo(topicView)
            $0.trailing.equalTo(topicView)
            $0.top.equalTo(topicView.snp.bottom)
            $0.bottom.equalToSuperview().offset(-12)
        }
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.darkText

        initializeLongPressGestureRecognizer()
    }

    //长按手势
    func initializeLongPressGestureRecognizer() {
        let method = #selector(longPressGestureClick as (UILongPressGestureRecognizer) -> ())
        let longPressGestureRecognizer = UILongPressGestureRecognizer.init(target: self, action: method)
        longPressGestureRecognizer.numberOfTapsRequired = 0// 设置几次长按触发事件
        longPressGestureRecognizer.numberOfTouchesRequired = 1// 设置几个手指长按
        longPressGestureRecognizer.minimumPressDuration = 0.5// 设置长按的时间间隔
        longPressGestureRecognizer.allowableMovement = 10// 设置长按期间可移动的距离
        self.contentView.addGestureRecognizer(longPressGestureRecognizer)
    }

    @objc func longPressGestureClick(gesture: UILongPressGestureRecognizer) -> Void {
        guard let cellViewModel = cellViewModel as? UserProfileTextCellViewModel else {
            return
        }
        if gesture.state == .began {
            setLogPressHighlighted(true, animated: true)
        } else {
            setLogPressHighlighted(false, animated: true)
        }

        if gesture.state == .ended {
            cellViewModel.longPressGestureClick()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var cellViewModel: Any? {
        didSet {
            guard let cellViewModel = cellViewModel as? UserProfileTextCellViewModel else {
                return
            }
            topicView.label.text = cellViewModel.model?.key
            titleLabel.text = cellViewModel.model?.value
        }
    }

    static var identifier: String {
        return String(describing: self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // 高亮状态
    func setLogPressHighlighted(_ highlighted: Bool, animated: Bool) {
        guard let cellViewModel = cellViewModel as? UserProfileTextCellViewModel, let copyValue = cellViewModel.model?.copyValue, !copyValue.isEmpty else {
            return
        }
        if (highlighted) {
            self.contentView.backgroundColor = UIColor.lightGray
            self.topicView.backgroundColor = UIColor.lightGray
        } else {
            // 增加延迟消失动画效果，提升用户体验
            UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveEaseInOut, animations: {
                self.contentView.backgroundColor = UIColor.white
                self.topicView.backgroundColor = UIColor.white
            }, completion: nil)
        }
    }
}
