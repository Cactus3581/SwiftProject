//
//  UserProfileTableHeaderView.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2020/3/12.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class UserProfileTableHeaderView: UIView {

    let button: UIButton?
    let ctaView: UserProfileCTAView?
    let coverImageView: UIImageView?

    override init(frame: CGRect) {

        let button: UIButton = UIButton()
        self.button = button

        let coverImageView: UIImageView = UIImageView()
        self.coverImageView = coverImageView



        let ctaView = UserProfileCTAView()
        self.ctaView = ctaView


        super.init(frame: frame)

        self.backgroundColor = UIColor.lightGray



        self.addSubview(coverImageView)
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
            $0.centerY.equalTo(self.coverImageView!.snp_bottom)
        }

        ctaView.layer.cornerRadius = 8

        self.addSubview(button)
         button.snp.makeConstraints {
             $0.center.equalToSuperview()
         }
        button.setTitleColor(UIColor.white,for: .normal)
        button.addTarget(self, action: #selector(click), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var viewModel: UserProfileViewModel? {
        didSet {
            button?.setTitle(viewModel?.model?.header?.title, for: .normal)
            self.ctaView?.ctaList = viewModel?.ctaList
        }
    }

    @objc func click(){
        self.viewModel?.headerClick()
    }
}
