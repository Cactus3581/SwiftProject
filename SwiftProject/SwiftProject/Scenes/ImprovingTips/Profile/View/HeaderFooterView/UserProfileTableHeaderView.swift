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
    weak var dependLayoutView: UIView!
    weak var dependLayoutView1: UIView!
    weak var ctaView: UserProfileCTAView?
    weak var ctaAnimationView: UserProfileShadowView?

    static let bottom: CGFloat = 15

    override init(frame: CGRect) {

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

        let dependLayoutView = UIView()
        self.dependLayoutView = dependLayoutView

        let dependLayoutView1 = UIView()
        self.dependLayoutView1 = dependLayoutView1

        let ctaAnimationView = UserProfileShadowView()
        self.ctaAnimationView = ctaAnimationView

        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        self.addSubview(dependLayoutView)
        self.addSubview(dependLayoutView1)

        self.addSubview(coverImageView)
        self.addSubview(ctaAnimationView)
        self.addSubview(ctaView)
        self.addSubview(companyLabel)
        self.addSubview(nameLabel)
        self.addSubview(tagsView)

        let imageHeight = (UIScreen.main.bounds.size.width / (375.0 / 330.0))
        coverImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(imageHeight)
        }
        dependLayoutView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(imageHeight)
        }
        dependLayoutView1.snp.makeConstraints {
            $0.centerY.equalTo(dependLayoutView.snp.bottom)
            $0.height.equalTo(100)
            $0.bottom.equalToSuperview().offset(-UserProfileTableHeaderView.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        ctaView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-UserProfileTableHeaderView.bottom)
        }
        ctaAnimationView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-UserProfileTableHeaderView.bottom)
            $0.height.equalTo(ctaView.snp.height)
        }
        
        companyLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalTo(dependLayoutView1.snp.top).offset(-20)
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

        ctaAnimationView.backgroundColor = UIColor.white
        ctaView.backgroundColor = UIColor.white
        ctaView.layer.cornerRadius = UserProfileCTAView.cornerRadius
        ctaView.layer.masksToBounds = true

        ctaAnimationView.layer.cornerRadius = UserProfileCTAView.cornerRadius

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
        //nameLabel.setContentHuggingPriority(.defaultLow, for: .vertical)// 抗拉伸
        let tagsViewWidth = tagsView.bounds.size.width
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()
        // 导航高度会变，所以会引起动画效果
        /*
        nameLabel.snp.updateConstraints() {
            $0.top.equalToSuperview().offset(self.safeAreaInsets.top+44).priority(.low)
        }
         */
    }

    var viewModel: UserProfileViewModel? {
        didSet {
            nameLabel?.text = viewModel?.model?.userInfo?.userName
            companyLabel?.text = viewModel?.model?.userInfo?.tenantName
            self.ctaView?.ctaList = viewModel?.ctaList
//            self.tagsView.tags = viewModel?.tags
//            self.tagsView.setNeedsLayout()
//            self.tagsView.layoutIfNeeded()
//
//            let nameLastLineWidth = self.nameLabel.bounds.size.width
//            let tagsWidth = self.tagsView.bounds.size.width
//            let totalWidth = self.bounds.size.width - 16*2
//            if totalWidth < nameLastLineWidth + tagsWidth {
//                // tagsView 换行
//            } else {
//                // tagsView 跟在名字后面
//            }
        }
    }
    
    @objc func click(){
        self.viewModel?.headerClick()
    }
}

extension CALayer {

    func sp_setShadow(shadowColor: UIColor, opacity: Float, offset: CGSize,  shadowRadius: CGFloat) {
        self.shadowColor = shadowColor.cgColor // 设置阴影颜色
        self.shadowOpacity = opacity // 设置透明度
        self.shadowOffset = offset // 设置阴影偏移量
        self.shadowRadius = shadowRadius // 设置阴影半径
    }

    enum SPShadowPathDirection {
        case top, left, bottom, right, topRL, bottomRL, around
    }

    func sp_setShadowPath(direction: SPShadowPathDirection, shadowColor: UIColor, shadowOpacity: Float, shadowRadius: CGFloat,  shadowPathOffset: CGFloat) {

        self.masksToBounds = false
        self.shadowColor = shadowColor.cgColor // 阴影颜色
        self.shadowOpacity = shadowOpacity // 阴影透明度，默认0
        self.shadowRadius = shadowRadius //阴影半径/模糊，默认3
        self.shadowOffset = CGSize(width: 0, height: 0) //阴影偏移，默认(0, -3)

        var shadowRect = CGRect(x: 0, y: 0, width: 0, height: 0)
        let width = self.bounds.size.width
        let height = self.bounds.size.height

//        switch direction {
//        case .top:
//            shadowRect = CGRect(x: 0, y: -shadowPathOffset, width: width, height: shadowPathOffset)
//        case .left:
//            shadowRect = CGRect(x: -shadowPathOffset, y: 0, width: shadowPathOffset, height: height)
//        case .bottom:
//            shadowRect = CGRect(x: 0, y: height, width: width, height: shadowPathOffset)
//        case .right:
//            shadowRect = CGRect(x: width, y: 0, width: shadowPathOffset, height: height)
//        case .topRL:
//            shadowRect = CGRect(x: -shadowPathOffset, y: -shadowPathOffset, width: width + shadowPathOffset*2, height: height + shadowPathOffset)
//        case .bottomRL:
//            shadowRect = CGRect(x: -shadowPathOffset, y: 0, width: width + shadowPathOffset*2, height: height + shadowPathOffset)
//        case .around:
//            shadowRect = CGRect(x: -shadowPathOffset, y: -shadowPathOffset, width: width + shadowPathOffset*2, height: height + shadowPathOffset*2)
//        }

        switch direction {
        case .top:
            shadowRect = CGRect(x: 0, y: -shadowPathOffset/2, width: width, height: shadowPathOffset)
        case .left:
            shadowRect = CGRect(x: -shadowPathOffset/2, y: 0, width: shadowPathOffset, height: height)
        case .bottom:
            shadowRect = CGRect(x: 0, y: height - shadowPathOffset/2, width: width, height: shadowPathOffset)
        case .right:
            shadowRect = CGRect(x: width - -shadowPathOffset/2, y: 0, width: shadowPathOffset, height: height)
        case .topRL:
            shadowRect = CGRect(x: -shadowPathOffset, y: -shadowPathOffset, width: width + shadowPathOffset*2, height: height + shadowPathOffset)
        case .bottomRL:
            shadowRect = CGRect(x: -shadowPathOffset, y: 0, width: width + shadowPathOffset*2, height: height + shadowPathOffset)
        case .around:
            shadowRect = CGRect(x: -shadowPathOffset/2, y: -shadowPathOffset/2, width: width + shadowPathOffset, height: height + shadowPathOffset)
        }

        let path = UIBezierPath(rect: shadowRect)
        self.shadowPath = path.cgPath
    }

    func sp_setShadow(color: UIColor? = .black,
                       alpha: CGFloat = 0.5,
                       x: CGFloat = 0, y: CGFloat = 2,
                       blur: CGFloat = 4,
                       spread: CGFloat = 0) {

        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur * 0.5
        shadowColor = color?.cgColor
        shadowOpacity = Float(alpha)
        let rect = bounds.insetBy(dx: -spread, dy: -spread)
        let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        shadowPath = path.cgPath
    }
}
