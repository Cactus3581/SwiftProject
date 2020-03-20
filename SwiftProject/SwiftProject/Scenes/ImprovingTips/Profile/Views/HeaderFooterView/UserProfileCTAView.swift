//
//  UserProfileCTAView.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/19.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit



class UserProfileCTAView: UIView {
    
    var stackView: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        
        //创建StackView
        let stackView = UIStackView()
        self.stackView = stackView
        stackView.clipsToBounds = true
        self.stackView.axis = .horizontal
        self.stackView.spacing = 0 //设置子视图最小间距
        self.stackView.distribution = .equalSpacing//子视图的分布比例
        self.stackView.alignment = .center//如果子控件水平布局, 则指子控件的垂直方向填充满stackView. 反之亦然
        self.stackView.isBaselineRelativeArrangement = false//视图间的垂直间隙是否根据基线测量得到（默认值：false）
        self.stackView.isLayoutMarginsRelativeArrangement = false//stack view 平铺其管理的视图时是否要参照它的布局边距（默认值：false）
        self.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
        }
        setShadow(view: self, shadowColor: UIColor.lightGray, opacity: 0.6, offset: CGSize(width: 0, height: 3), shadowRadius: 3)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var ctaList: Array<UserProfileCTAItemViewModel>? {
        didSet {
            guard let ctaList = ctaList else {
                return
            }
            
            for itemViewModel in ctaList {
                let view = UserProfileCTAItemView()
                stackView.addArrangedSubview(view)
                view.viewModel = itemViewModel
            }
        }
    }
    
    func setShadow(view: UIView, shadowColor: UIColor, opacity: Float, offset: CGSize,  shadowRadius: CGFloat) {
        //设置阴影颜色
        view.layer.shadowColor = shadowColor.cgColor
        //设置透明度
        view.layer.shadowOpacity = opacity
        //设置阴影偏移量
        view.layer.shadowOffset = offset
        //设置阴影半径
        view.layer.shadowRadius = shadowRadius
    }
}


class UserProfileCTAItemView: UIView  {
    let coverImageView: UIImageView?
    let label: UILabel?
    
    override init(frame: CGRect) {
        let coverImageView: UIImageView = UIImageView()
        self.coverImageView = coverImageView
        let label: UILabel = UILabel()
        self.label = label
        
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.addSubview(coverImageView)
        coverImageView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.width.equalTo(30)
            make.height.equalTo(coverImageView.snp_width).multipliedBy(1)
        }
        coverImageView.image = UIImage(named: "cactus_explicit")
        coverImageView.clipsToBounds = true
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.backgroundColor = UIColor.green
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(jump))
        coverImageView.isUserInteractionEnabled = true
        coverImageView.addGestureRecognizer(tap)
        
        self.addSubview(label)
        label.font = UIFont.systemFont(ofSize: 12)
        label.snp.makeConstraints{  (make) in
            make.centerX.bottom.equalToSuperview()
            make.top.equalTo(coverImageView.snp_bottom)
        }
    }
    
    
    
    @objc func jump() {
        self.viewModel?.jump()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var viewModel: UserProfileCTAItemViewModel? {
        didSet {
            self.label?.text = viewModel?.model?.title
            self.coverImageView?.image = UIImage(named: viewModel?.model?.imageUrl ?? "") 
        }
    }
}
