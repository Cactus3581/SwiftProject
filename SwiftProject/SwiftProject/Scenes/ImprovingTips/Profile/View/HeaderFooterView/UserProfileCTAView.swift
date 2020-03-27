//
//  UserProfileCTAView.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/19.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class UserProfileCTAView: UIView {

    weak var stackView: UIStackView!
    static let cornerRadius: CGFloat = 8

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        let stackView = UIStackView()
        self.stackView = stackView
        stackView.backgroundColor = UIColor.white
        self.stackView.axis = .horizontal
        self.stackView.spacing = 8 //设置子视图最小间距
        self.stackView.distribution = .fillEqually//子视图的分布比例
        self.stackView.alignment = .fill//如果子控件水平布局, 则指子控件的垂直方向填充满stackView. 反之亦然
        self.stackView.isBaselineRelativeArrangement = false//视图间的垂直间隙是否根据基线测量得到（默认值：false）
        self.stackView.isLayoutMarginsRelativeArrangement = false//stack view 平铺其管理的视图时是否要参照它的布局边距（默认值：false）
        self.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var ctaList: Array<UserProfileCTAItemViewModelProtocol>? {
        didSet {
            self.stackView.arrangedSubviews.forEach({ (view) in
                view.removeFromSuperview()
            })
            guard let ctaList = ctaList else {
                return
            }
            for itemViewModel in ctaList {
                // 方案1: 使用工厂方法，这种略麻烦，也是依赖具体参数，还得注册，还得写工厂方法
                if var view = UserProfileViewModelFactory.viewWithType(type: itemViewModel.viewType), let itemView = view as? UIView {
                    let preferredMaxLayoutWidth: CGFloat = (UIScreen.main.bounds.size.width - CGFloat(32) - CGFloat(8 * (ctaList.count-1)))  / CGFloat(ctaList.count)
                    view.preferredMaxLayoutWidth = preferredMaxLayoutWidth
                    view.viewModel = itemViewModel
                    stackView.addArrangedSubview(itemView)
                }

                // 方案2: 使用类反射，也是依赖具体参数，而且该参数必须是view的类名
                /*
                if let viewClass = getCTAItemViewClassType(className: itemViewModel.viewType) {
                    let view = viewClass.init()
                    stackView.addArrangedSubview(view)
                    if var view = view as? UserProfileCTAItemViewProtocol {
                        view.viewModel = itemViewModel
                    }
                }
                 */
            }
        }
    }

    func getCTAItemViewClassType(className: String) -> UIView.Type? {
        guard let nameSpace = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else {
            return nil
        }

        guard let viewClass = NSClassFromString(nameSpace + "." + className) as? UIView.Type else {
             return nil
         }
        return viewClass
    }
}

protocol UserProfileCTAItemViewProtocol {
    // 使用工厂方法创建的
    static func canHandle(type: String) -> Bool
    init()
    var viewModel: UserProfileCTAItemViewModelProtocol? { set get }// 提供赋值方式
    var preferredMaxLayoutWidth: CGFloat? { set get }
}

extension UserProfileCTAItemViewProtocol {
    static func canHandle(type: String) -> Bool {return false}
    init(){self.init()}
    var viewModel: UserProfileCTAItemViewModelProtocol? { set{} get{return nil} }
    var preferredMaxLayoutWidth: CGFloat? { set{} get{return nil} }
}

class UserProfileCTAItemView: UIView, UserProfileCTAItemViewProtocol  {
    weak var coverImageView: UIImageView!
    weak var label: VerticalAlignmentLabel!

    static func canHandle(type: String) -> Bool {
        if type == "phone" {
            return true
        }
        return true
    }

    var preferredMaxLayoutWidth: CGFloat? {
        didSet {
            guard let preferredMaxLayoutWidth = preferredMaxLayoutWidth else {
                return
            }
            label.preferredMaxLayoutWidth = preferredMaxLayoutWidth
        }
    }
    
    override init(frame: CGRect) {
        let coverImageView: UIImageView = UIImageView()
        self.coverImageView = coverImageView
        let label = VerticalAlignmentLabel()
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
        coverImageView.backgroundColor = UIColor.lightGray
        coverImageView.clipsToBounds = true
        coverImageView.contentMode = .scaleAspectFill

        self.addSubview(label)

        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.snp.makeConstraints{ (make) in
            make.top.equalTo(coverImageView.snp.bottom).offset(8)
            make.bottom.equalToSuperview().offset((-14))
            make.leading.trailing.equalToSuperview() // 加上动画不自然
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(didClick))
        self.addGestureRecognizer(tap)
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

/// label 的对齐类型
public enum VerticalAlignment {
    case top
    case middle
    case bottom
}

class VerticalAlignmentLabel: UILabel {

    var verticalAlignment : VerticalAlignment?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.verticalAlignment = VerticalAlignment.top
    }

    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        var textRect: CGRect = super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
        switch self.verticalAlignment {
        case .top?:
            textRect.origin.y = bounds.origin.y
        case .bottom?:
            textRect.origin.y = bounds.origin.y + bounds.size.height - textRect.size.height
        case .middle?:
            fallthrough
        default:
            textRect.origin.y = bounds.origin.y + (bounds.size.height - textRect.size.height) / 2.0
        }
        return textRect
    }

    override func draw(_ rect: CGRect) {
        let rect : CGRect = self.textRect(forBounds: rect, limitedToNumberOfLines: self.numberOfLines)
        super.drawText(in: rect)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
