//
//  UserProfilePhoneTableViewCell.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/20.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class UserProfilePhoneTableViewCell: UITableViewCell, UserProfileTableViewCellProtocol {
    
    weak var phoneLabel: UILabel!
    weak var showButton: UIButton!
    weak var arrowImageView: UIImageView!
    weak var lineView: UIView!
    var indexPath: IndexPath?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {

        let phoneLabel: UILabel = UILabel()
        self.phoneLabel = phoneLabel
        
        let showButton: UIButton = UIButton()
        self.showButton = showButton

        let arrowImageView = UIImageView()
        self.arrowImageView = arrowImageView

        let lineView: UIView = UIView()
        self.lineView = lineView

        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = UIColor.white
        
        self.contentView.addSubview(phoneLabel)
        phoneLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-12)
        }
        phoneLabel.font = UIFont.systemFont(ofSize: 16)
        phoneLabel.textColor = UIColor.darkText
        phoneLabel.numberOfLines = 0
        
        self.contentView.addSubview(showButton)
        showButton.snp.makeConstraints {
            $0.leading.equalTo(phoneLabel.snp.trailing).offset(15)
            $0.centerY.equalTo(phoneLabel)
        }
        showButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        showButton.setTitleColor(UIColor.blue,for: .normal)
        showButton.addTarget(self, action: #selector(show), for: .touchUpInside)

        self.contentView.addSubview(arrowImageView)
        arrowImageView.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalTo(phoneLabel)
        }
        arrowImageView.image = UIImage(named: "icon_back")
        
        self.contentView.addSubview(lineView)
        lineView.backgroundColor = UIColor.lightGray
        lineView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1/UIScreen.main.scale)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var cellViewModel: Any? {
        didSet {
            guard let cellViewModel = cellViewModel as? UserProfilePhoneCellViewModel else {
                return
            }
            phoneLabel.text = cellViewModel.model?.number
            if let isShow = cellViewModel.isShow {
                if isShow {
                    showButton.setTitle("显示", for: .normal)
                    phoneLabel.text = cellViewModel.model?.number
                } else {
                    showButton.setTitle("隐藏", for: .normal)
                    phoneLabel.text = cellViewModel.model?.number
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
                        phoneLabel.text = cellViewModel.model?.number
                    } else {
                        showButton.setTitle("隐藏", for: .normal)
                        phoneLabel.text = cellViewModel.model?.number
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
}
