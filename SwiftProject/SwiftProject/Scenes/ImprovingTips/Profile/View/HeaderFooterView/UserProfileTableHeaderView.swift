//
//  UserProfileTableHeaderView.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/12.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class UserProfileTableHeaderView: UIView {
    
    weak var nameLabel: UILabel!
    weak var ctaView: UserProfileCTAView!
    weak var coverImageView: UIImageView!
    weak var backView: UIView!

    static let height: CGFloat = 300
    static let bottom: CGFloat = 15
    static let cornerRadius: CGFloat = 8

    override init(frame: CGRect) {
        
        let nameLabel = UILabel()
        self.nameLabel = nameLabel
        
        let backView = UIView()
        self.backView = backView
        
        let coverImageView: UIImageView = UIImageView()
        self.coverImageView = coverImageView

        let ctaView = UserProfileCTAView()
        self.ctaView = ctaView
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white

        self.addSubview(backView)
        backView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-(UserProfileCTAView.height/2.0+UserProfileTableHeaderView.bottom))
        }

        self.addSubview(coverImageView)
        coverImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-(UserProfileCTAView.height/2.0+UserProfileTableHeaderView.bottom))
        }
        
        coverImageView.image = UIImage(named: "cactus_explicit")
        coverImageView.clipsToBounds = true
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.backgroundColor = UIColor.lightGray
        
        self.addSubview(ctaView)
        ctaView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(UserProfileTableHeaderView.bottom)
            $0.trailing.equalToSuperview().offset(-UserProfileTableHeaderView.bottom)
            $0.height.equalTo(UserProfileCTAView.height)
            $0.centerY.equalTo(self.backView.snp_bottom)
        }
        ctaView.layer.cornerRadius = UserProfileTableHeaderView.cornerRadius
        
        self.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var viewModel: UserProfileViewModel? {
        didSet {
            nameLabel?.text = viewModel?.model?.userInfo?.userName
            self.ctaView?.ctaList = viewModel?.ctaList
        }
    }
    
    @objc func click(){
        self.viewModel?.headerClick()
    }
}
