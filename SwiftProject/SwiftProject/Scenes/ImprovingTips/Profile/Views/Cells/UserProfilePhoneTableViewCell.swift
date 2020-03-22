//
//  UserProfilePhoneTableViewCell.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/20.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class UserProfilePhoneTableViewCell: UITableViewCell, UserProfileTableViewCellProtocol {
    
    let phoneLabel: UILabel?
    let showButton: UIButton?
    let lineView: UIView?
    var indexPath: NSIndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        
        let phoneLabel: UILabel = UILabel()
        self.phoneLabel = phoneLabel
        
        let showButton: UIButton = UIButton()
        self.showButton = showButton
        
        let lineView: UIView = UIView()
        self.lineView = lineView
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = UIColor.white
        
        self.contentView.addSubview(phoneLabel)
        phoneLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }
        phoneLabel.font = UIFont.systemFont(ofSize: 16)
        phoneLabel.textColor = UIColor.darkText
        
        self.contentView.addSubview(showButton)
        showButton.snp.makeConstraints {
            $0.leading.equalTo(phoneLabel.snp_trailing).offset(15)
            $0.centerY.equalToSuperview()
        }
        showButton.setTitleColor(UIColor.blue,for: .normal)
        showButton.addTarget(self, action: #selector(show), for: .touchUpInside)
        
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
            phoneLabel?.text = cellViewModel.model?.phone
            if let isShow = cellViewModel.model?.isShow {
                if isShow {
                    showButton?.setTitle("显示", for: .normal)
                } else {
                    showButton?.setTitle("隐藏", for: .normal)
                }
            }
        }
    }
    
    
    @objc func show() {
        //vm绑定view
        guard let cellViewModel1 = cellViewModel as? UserProfilePhoneCellViewModel else {
            return
        }
        // 使用KVO
        //cellViewModel1.show(indexPath: self.indexPath!)

        //使用闭包
        cellViewModel1.show1(indexPath: self.indexPath!) {
            if indexPath == self.indexPath {
                // update
                guard let cellViewModel = cellViewModel as? UserProfilePhoneCellViewModel else {
                    return
                }
                if let isShow = cellViewModel.model?.isShow {
                    if isShow {
                        showButton?.setTitle("显示", for: .normal)
                    } else {
                        showButton?.setTitle("隐藏", for: .normal)
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
