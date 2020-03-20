//
//  UserProfileTableHeaderView.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/12.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class UserProfileTableHeaderView: UIView {
    
    let nameLabel: UILabel?
    let ctaView: UserProfileCTAView?
    let coverImageView: UIImageView?
    let backView: UIView?
    
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
        self.addSubview(coverImageView)
        self.addSubview(backView)
        
        backView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-45)
        }
        
        coverImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-45)
        }
        
        coverImageView.image = UIImage(named: "cactus_explicit")
        coverImageView.clipsToBounds = true
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.backgroundColor = UIColor.lightGray
        
        self.addSubview(ctaView)
        ctaView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().offset(-15)
            $0.height.equalTo(60)
            $0.centerY.equalTo(self.backView!.snp_bottom)
        }
        
        ctaView.layer.cornerRadius = 8
        
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
            nameLabel?.text = viewModel?.model?.info?.name
            self.ctaView?.ctaList = viewModel?.ctaList
        }
    }
    
    @objc func click(){
        self.viewModel?.headerClick()
    }
    
    
}
