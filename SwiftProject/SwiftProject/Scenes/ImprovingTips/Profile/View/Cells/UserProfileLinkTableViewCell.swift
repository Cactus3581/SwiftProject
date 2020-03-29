//
//  UserProfileLinkTableViewCell.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/24.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class UserProfileLinkTableViewCell: UITableViewCell, UserProfileTableViewCellProtocol {

    weak var topicView: UserProfileTopicView!
    weak var titleLabel: UILabel!
    weak var arrowImageView: UIImageView!
    var indexPath: IndexPath?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {

        let topicView = UserProfileTopicView()
        self.topicView = topicView

        let label = UILabel()
        self.titleLabel = label

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
            $0.leading.equalTo(topicView)
            $0.trailing.greaterThanOrEqualTo(arrowImageView.snp.leading).offset(-10)
        }
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.darkText

        arrowImageView.setContentHuggingPriority(.required, for: .horizontal)// 抗拉伸
        arrowImageView.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalTo(label)
        }
        arrowImageView.image = UIImage(named: "icon_back")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var cellViewModel: Any? {
        didSet {
            guard let cellViewModel = cellViewModel as? UserProfileLinkCellViewModel else {
                return
            }
            if let linkTitle = cellViewModel.model?.linkTitle, !linkTitle.isEmpty {
                // 有section标题，即有linktitle
                topicView.label.text = cellViewModel.model?.key
                titleLabel.text = cellViewModel.model?.linkTitle
                topicView.snp.updateConstraints {
                    $0.top.equalToSuperview().offset(12)
                }
                titleLabel.snp.updateConstraints {
                    $0.bottom.equalToSuperview().offset(-12)
                }
            } else {
                // 无section标题，即无linktitle
                topicView.label.text = nil
                titleLabel.text = cellViewModel.model?.key

                topicView.snp.updateConstraints {
                    $0.top.equalToSuperview().offset(23)
                }
                titleLabel.snp.updateConstraints {
                    $0.bottom.equalToSuperview().offset(-23)
                }
            }

            if let url = cellViewModel.model?.url, !url.isEmpty {
                self.arrowImageView.isHidden = false
            } else {
                self.arrowImageView.isHidden = true
            }
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

        guard let cellViewModel = cellViewModel as? UserProfileLinkCellViewModel, let url = cellViewModel.model?.url, !url.isEmpty else {
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
