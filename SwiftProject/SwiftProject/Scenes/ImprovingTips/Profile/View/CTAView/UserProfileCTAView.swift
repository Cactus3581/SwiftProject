//
//  UserProfileCTAView.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/19.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class UserProfileCTAView: UIView {

    weak var contentView: UIView!
    weak var stackView: UIStackView!
    static let cornerRadius: CGFloat = 8
    static let height: CGFloat = 90

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        let contentView = UIView()
        self.contentView = contentView
        self.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        contentView.layer.cornerRadius = UserProfileCTAView.cornerRadius
        contentView.layer.masksToBounds = true
        //创建StackView
        let stackView = UIStackView()
        self.stackView = stackView
        stackView.backgroundColor = UIColor.white
        stackView.layer.masksToBounds = true
        self.stackView.axis = .horizontal
        self.stackView.spacing = 8 //设置子视图最小间距
        self.stackView.distribution = .fillEqually//子视图的分布比例
        self.stackView.alignment = .center//如果子控件水平布局, 则指子控件的垂直方向填充满stackView. 反之亦然
        self.stackView.isBaselineRelativeArrangement = false//视图间的垂直间隙是否根据基线测量得到（默认值：false）
        self.stackView.isLayoutMarginsRelativeArrangement = false//stack view 平铺其管理的视图时是否要参照它的布局边距（默认值：false）
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        setShadow(view: self, shadowColor: UIColor.lightGray, opacity: 0.6, offset: CGSize(width: 0, height: 3), shadowRadius: 3)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var ctaList: Array<UserProfileCTAItemViewModelProtocol>? {
        didSet {
            guard let ctaList = ctaList else {
                return
            }
            for itemViewModel in ctaList {
                // 方案1: 使用工厂方法，这种略麻烦，也是依赖具体参数，还得注册，还得写工厂方法
                if var view = UserProfileViewModelFactory.viewWithType(type: itemViewModel.viewType) {
                    stackView.addArrangedSubview(view as! UIView)
                    view.viewModel = itemViewModel
                }
                
                // 方案2: 使用类反射，也是依赖具体参数，而且该参数必须是view的类名
//                if let viewClass = getCTAItemViewClassType(className: itemViewModel.viewType) {
//                    let view = viewClass.init()
//                    stackView.addArrangedSubview(view)
//                    if var view = view as? UserProfileCTAItemViewProtocol {
//                        view.viewModel = itemViewModel
//                    }
//                }
            }
        }
    }

    func getCTAItemViewClassType(className: String) -> UIView.Type? {
        guard let nameSpace = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else {
            print("获取命名空间失败")
            return nil
        }

        guard let viewClass = NSClassFromString(nameSpace + "." + className) as? UIView.Type else {
             return nil
         }

        return viewClass
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

protocol UserProfileCTAItemViewProtocol {
    // 使用工厂方法创建的
    static func canHandle(type: String) -> Bool
    init()
    var viewModel: UserProfileCTAItemViewModelProtocol? { set get }// 提供赋值方式
}

extension UserProfileCTAItemViewProtocol {
    static func canHandle(type: String) -> Bool {return false}
    init(){self.init()}
    var viewModel: UserProfileCTAItemViewModelProtocol? { set{} get{return nil} }
}

class UserProfileCTAItemView: UIView, UserProfileCTAItemViewProtocol  {
    let coverImageView: UIImageView?
    let label: UILabel?

    static func canHandle(type: String) -> Bool {
        if type == "phone" {
            return true
        }
        return true
    }

    override init(frame: CGRect) {
        let coverImageView: UIImageView = UIImageView()
        self.coverImageView = coverImageView
        let label: UILabel = UILabel()
        self.label = label
        
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.addSubview(coverImageView)
        coverImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(16)
            make.centerX.equalToSuperview()
            make.width.equalTo(24)
            make.height.equalTo(coverImageView.snp.width).multipliedBy(1)
        }
        coverImageView.image = UIImage(named: "cactus_explicit")
        coverImageView.clipsToBounds = true
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.backgroundColor = UIColor.green
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didClick))
        coverImageView.isUserInteractionEnabled = true
        coverImageView.addGestureRecognizer(tap)

        self.addSubview(label)
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.snp.makeConstraints{  (make) in
            make.top.equalTo(coverImageView.snp.bottom).offset(8)
//            make.bottom.equalToSuperview().offset((-14))
            make.centerX.bottom.equalToSuperview()
//            make.leading.trailing.equalToSuperview() // 加上动画不自然
        }
    }

    @objc func didClick() {
        self.viewModel?.didClick()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var viewModel: UserProfileCTAItemViewModelProtocol? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            self.label?.text = viewModel.title
            self.coverImageView?.image = UIImage(named: viewModel.imageUrl ?? "")
        }
    }
}
