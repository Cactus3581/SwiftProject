//
//  UserProfileTableHeaderView.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/12.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class UserProfileTableHeaderView: UIView {

    weak var coverImageView: UIImageView!
    weak var nameLabel: UILabel!
    weak var tagsView: UserProfileTagsView!
    weak var companyLabel: UILabel!
    weak var ctaView: UserProfileCTAView!
    weak var backView: UIView!

    static let bottom: CGFloat = 15

    override init(frame: CGRect) {

        let backView = UIView()
        self.backView = backView

        let coverImageView = UIImageView()
        self.coverImageView = coverImageView

        let ctaView = UserProfileCTAView()
        self.ctaView = ctaView

        let companyLabel = UILabel()
        self.companyLabel = companyLabel

        let nameLabel = UILabel()
        self.nameLabel = nameLabel

        let tagsView = UserProfileTagsView()
        self.tagsView = tagsView

        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        self.addSubview(backView)
        self.addSubview(coverImageView)
        self.addSubview(ctaView)
        self.addSubview(companyLabel)
        self.addSubview(nameLabel)
        self.addSubview(tagsView)

        ctaView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(UserProfileCTAView.height)
            $0.bottom.equalToSuperview().offset(-UserProfileTableHeaderView.bottom)
        }
        backView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-UserProfileTableHeaderView.bottom - (UserProfileCTAView.height/2.0))
        }
        coverImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            //$0.bottom.equalTo(ctaView.snp.centerY)
            $0.bottom.equalToSuperview().offset(-UserProfileTableHeaderView.bottom - (UserProfileCTAView.height/2.0))
        }
        companyLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalTo(backView).offset(-UserProfileCTAView.height/2 - 20)
        }
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(64).priority(.low)
            $0.leading.equalTo(companyLabel)
            $0.trailing.equalTo(companyLabel)
            $0.bottom.equalTo(companyLabel.snp.top).offset(-20)
        }
        tagsView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(64).priority(.low)
            $0.leading.equalTo(companyLabel)
            $0.trailing.equalTo(companyLabel)
            $0.bottom.equalTo(companyLabel.snp.top).offset(-20)
        }

        ctaView.layer.cornerRadius = UserProfileCTAView.cornerRadius



        coverImageView.image = UIImage(named: "cactus_explicit")
        coverImageView.clipsToBounds = true
        coverImageView.contentMode = .scaleAspectFill


        companyLabel.font = UIFont.systemFont(ofSize: 16)
        companyLabel.textColor = UIColor.white
        companyLabel.numberOfLines = 0


        nameLabel.font = UIFont.systemFont(ofSize: 32)
        nameLabel.textColor = UIColor.white
        nameLabel.numberOfLines = 5
        nameLabel.minimumScaleFactor = 0.68
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical) //抗压缩
        nameLabel.setContentHuggingPriority(.defaultLow, for: .vertical)// 抗拉伸



        let tagsViewWidth = tagsView.bounds.size.width


    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()
        // 导航高度会变，所以会引起动画效果
//        nameLabel.snp.updateConstraints() {
//            $0.top.equalToSuperview().offset(self.safeAreaInsets.top+44).priority(.low)
//        }
    }
    
    var viewModel: UserProfileViewModel? {
        didSet {
            nameLabel?.text = viewModel?.model?.userInfo?.userName
            companyLabel?.text = viewModel?.model?.userInfo?.tenantName
            self.ctaView?.ctaList = viewModel?.ctaList
        }
    }
    
    @objc func click(){
        self.viewModel?.headerClick()
    }
}
