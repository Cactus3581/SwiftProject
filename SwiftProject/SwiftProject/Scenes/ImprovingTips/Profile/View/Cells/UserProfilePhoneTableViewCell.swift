//
//  UserProfilePhoneTableViewCell.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/20.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class UserProfilePhoneTableViewCell: UITableViewCell, UserProfileTableViewCellProtocol {

    weak var topicView: UserProfileTopicView!
    weak var label: UILabel!
    weak var showButton: UIButton!
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
        
        let showButton: UIButton = UIButton()
        self.showButton = showButton

        let arrowImageView = UIImageView()
        self.arrowImageView = arrowImageView

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
            $0.top.equalTo(topicView.snp.bottom)
            $0.bottom.equalToSuperview().offset(-12)
            $0.leading.equalTo(topicView)
        }

        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.darkText
        label.numberOfLines = 0
        
        self.contentView.addSubview(showButton)
        showButton.snp.makeConstraints {
            $0.leading.equalTo(label.snp.trailing).offset(15)
            $0.centerY.equalTo(label)
        }
        showButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        showButton.setTitleColor(UIColor.blue,for: .normal)
        showButton.addTarget(self, action: #selector(show), for: .touchUpInside)

        self.contentView.addSubview(arrowImageView)
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
            guard let cellViewModel = cellViewModel as? UserProfilePhoneCellViewModel else {
                return
            }
            topicView.label.text = cellViewModel.model?.key
            label.text = cellViewModel.model?.number
            if let isShow = cellViewModel.isShow {
                if isShow {
                    showButton.setTitle("显示", for: .normal)
                    label.text = cellViewModel.model?.number
                } else {
                    showButton.setTitle("隐藏", for: .normal)
                    label.text = cellViewModel.model?.number
                }
            }
        }
    }
    
    @objc func show() {

        guard let cellViewModel = cellViewModel as? UserProfilePhoneCellViewModel else {
            return
        }

        // 使用KVO
        //cellViewModel1.show(indexPath: self.indexPath!)

        // 使用闭包
        cellViewModel.show1(indexPath: self.indexPath!) {
            if indexPath == self.indexPath {
                // update
                if let isShow = cellViewModel.isShow {
                    if isShow {
                        showButton.setTitle("显示", for: .normal)
                        label.text = cellViewModel.model?.number
                    } else {
                        showButton.setTitle("隐藏", for: .normal)
                        label.text = cellViewModel.model?.number
                    }
                }
            }
        }
    }
    
    static var identifier: String {
        return String(describing: self)
    }

    override func prepareForReuse() {
        // 防止重用导致的vm和cell的不匹配
        // block = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // 高亮状态
      override func setHighlighted(_ highlighted: Bool, animated: Bool) {
          super.setHighlighted(highlighted, animated: animated)

          guard let cellViewModel = cellViewModel as? UserProfilePhoneCellViewModel else {
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
