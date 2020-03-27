//
//  UserProfileCommonTableViewCell.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/19.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class UserProfileTextTableViewCell: UITableViewCell, UserProfileTableViewCellProtocol {
    
    let titleLabel: UILabel!
    let lineView: UIView!
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {

        let label: UILabel = UILabel()
        self.titleLabel = label
        
        let lineView: UIView = UIView()
        self.lineView = lineView
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = UIColor.white
        
        self.contentView.addSubview(label)
        label.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-12)
        }
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.darkText
        
        self.contentView.addSubview(lineView)
        lineView.backgroundColor = UIColor.lightGray
        lineView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1/UIScreen.main.scale)
        }

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
            titleLabel.text = cellViewModel.model?.value
        }
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
