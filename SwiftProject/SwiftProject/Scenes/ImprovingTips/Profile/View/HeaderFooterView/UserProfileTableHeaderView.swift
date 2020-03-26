//
//  UserProfileTableHeaderView.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/12.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class UserProfileTableHeaderView: UIView {

    weak var ctaView: UserProfileCTAView!
    weak var coverImageView: UIImageView!
    weak var companyLabel: UILabel!
    weak var nameLabel: UILabel!

    static let bottom: CGFloat = 15

    override init(frame: CGRect) {

        let coverImageView: UIImageView = UIImageView()
        self.coverImageView = coverImageView

        let ctaView = UserProfileCTAView()
        self.ctaView = ctaView

        let companyLabel = UILabel()
        self.companyLabel = companyLabel

        let nameLabel = UILabel()
        self.nameLabel = nameLabel

        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white

        self.addSubview(coverImageView)

        self.addSubview(ctaView)
        ctaView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(UserProfileCTAView.height)
            $0.bottom.equalToSuperview().offset(-UserProfileTableHeaderView.bottom)
        }

        ctaView.layer.cornerRadius = UserProfileCTAView.cornerRadius

        coverImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            //$0.bottom.equalTo(ctaView.snp.centerY)
            $0.bottom.equalToSuperview().offset(-(UserProfileCTAView.height/2.0+UserProfileTableHeaderView.bottom))
        }

        coverImageView.image = UIImage(named: "cactus_explicit")
        coverImageView.clipsToBounds = true
        coverImageView.contentMode = .scaleAspectFill

        self.addSubview(companyLabel)
        companyLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalTo(coverImageView).offset(-UserProfileCTAView.height/2 - 20)
        }
        companyLabel.font = UIFont.systemFont(ofSize: 16)
        companyLabel.textColor = UIColor.white
        companyLabel.numberOfLines = 0

        self.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(64).priority(999)
            $0.leading.equalTo(companyLabel)
            $0.trailing.equalTo(companyLabel)
            $0.bottom.equalTo(companyLabel.snp.top).offset(-20)
        }
        nameLabel.font = UIFont.systemFont(ofSize: 32)
        nameLabel.textColor = UIColor.white
        nameLabel.numberOfLines = 0
        nameLabel.minimumScaleFactor = 0.68
        nameLabel.adjustsFontSizeToFitWidth = true
        companyLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        nameLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()
        nameLabel.snp.updateConstraints() {
            $0.top.equalToSuperview().offset(self.safeAreaInsets.top+44).priority(999)
        }
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
