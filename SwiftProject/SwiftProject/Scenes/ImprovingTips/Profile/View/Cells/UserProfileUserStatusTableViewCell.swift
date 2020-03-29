//
//  UserProfileUserStatusTableViewCell.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/25.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class UserProfileUserStatusTableViewCell: UITableViewCell, UserProfileTableViewCellProtocol {

    weak var topicView: UserProfileTopicView!
    weak var label: UILabel!
    weak var arrowImageView: UIImageView!
    var indexPath: IndexPath?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {

        let topicView = UserProfileTopicView()
        self.topicView = topicView
        
        let label = UILabel()
        self.label = label

        let arrowImageView = UIImageView()
        self.arrowImageView = arrowImageView
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none

        self.contentView.backgroundColor = UIColor.white
        self.contentView.addSubview(topicView)
        self.contentView.addSubview(label)
        self.contentView.addSubview(arrowImageView)

        topicView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }

        label.snp.makeConstraints {
            $0.top.equalTo(topicView.snp.bottom)
            $0.bottom.equalToSuperview().offset(-12)
            $0.leading.trailing.equalTo(topicView)
        }
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.darkText

        arrowImageView.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalTo(label)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var cellViewModel: Any? {
        didSet {
            guard let cellViewModel = cellViewModel as? UserProfileUserStatusCellViewModel else {
                return
            }
            topicView.label.text = cellViewModel.model?.key
            label.text = cellViewModel.model?.statusInfo
        }
    }
    
    static var identifier: String {
        return String(describing: self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // 高亮状态
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
       super.setHighlighted(highlighted, animated: animated)
       guard let _ = cellViewModel as? UserProfileUserStatusCellViewModel else {
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
