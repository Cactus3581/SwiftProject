//
//  UserProfileTagsView.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/27.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class UserProfileTagsView: UIView {

    weak var stackView: UIStackView!

    override init(frame: CGRect) {
        let stackView = UIStackView()
        self.stackView = stackView
        
        super.init(frame: frame)

        stackView.backgroundColor = UIColor.white
        stackView.layer.masksToBounds = true
        self.stackView.axis = .horizontal
        self.stackView.spacing = 5//设置子视图最小间距
        self.stackView.distribution = .equalSpacing//子视图的分布比例
        self.stackView.alignment = .center//如果子控件水平布局, 则指子控件的垂直方向填充满stackView. 反之亦然
        self.stackView.isBaselineRelativeArrangement = false//视图间的垂直间隙是否根据基线测量得到（默认值：false）
        self.stackView.isLayoutMarginsRelativeArrangement = false//stack view 平铺其管理的视图时是否要参照它的布局边距（默认值：false）
        self.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.height.equalTo(20)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var tags: [UserProfileTagModel]? {
        didSet {
            guard let tags = tags else {
                return
            }
            for tag in tags {
                if let type = tag.type {
                    if type == 1 {
                        let view = UIView()

                        let label = UILabel()
                        label.font = UIFont.systemFont(ofSize: 12)
                        label.text = tag.text
                        view.backgroundColor = UIColor.yellow
                        view.addSubview(label)
                        label.snp.makeConstraints { (make) in
                            make.leading.equalToSuperview().offset(5)
                            make.trailing.equalToSuperview().offset(-5)
                            make.top.equalToSuperview().offset(5)
                            make.bottom.equalToSuperview().offset(-5)
                        }
                        stackView.addArrangedSubview(view)
                    } else if type == 2 {
                        let imageView = UIImageView()
                        imageView.clipsToBounds = true
                        imageView.contentMode = .scaleAspectFill
                        imageView.image = UIImage(named: "profilegender")
                        stackView.addArrangedSubview(imageView)
                    }
                }
            }
        }
    }
}

class UserProfileTagModel: NSObject {
    var type: Int?    // 图片还是文字
    var text: String?
    var imageName: String?
    override required init() {}
}
