//
//  UserProfileDepartmentTableViewCell.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/11.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class UserProfileDepartmentTableViewCell: UITableViewCell, UserProfileTableViewCellProtocol {

    weak var topicView: UserProfileTopicView!
    weak var titleLabel: UILabel!
    weak var button: UIButton!

    var indexPath: IndexPath?
    var maxLine = 3

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {

        let topicView = UserProfileTopicView()
        self.topicView = topicView
        
        let label = UILabel()
        self.titleLabel = label

        let button = UIButton()
        self.button = button

        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none

        self.contentView.backgroundColor = UIColor.white
        self.contentView.addSubview(topicView)
        self.contentView.addSubview(label)
        self.contentView.addSubview(button)

        topicView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }

        label.snp.makeConstraints {
            $0.top.equalTo(topicView.snp.bottom)
            $0.bottom.equalToSuperview().offset(-12)
            $0.leading.equalTo(topicView)
            $0.trailing.equalTo(topicView)
        }
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.darkText

        button.snp.makeConstraints {
            $0.top.equalTo(topicView.snp.bottom)
            $0.bottom.equalToSuperview().offset(-12)
            $0.leading.equalTo(topicView)
            $0.trailing.equalTo(topicView)
        }
    }

    func sda() {

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var cellViewModel: Any? {
        didSet {
            guard let cellViewModel = cellViewModel as? UserProfileDepartmentCellViewModel else {
                return
            }
            topicView.label.text = cellViewModel.topic
            titleLabel.text = cellViewModel.path
        }
    }

    static var identifier: String {
        return String(describing: self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

class UserProfileMultiDepartmentTableViewCell: UITableViewCell, UserProfileTableViewCellProtocol {

    weak var topicView: UserProfileTopicView!
    weak var dotView: UIView!
    weak var titleLabel: UILabel!
    var indexPath: IndexPath?
    var maxLine = 3

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {

        let topicView = UserProfileTopicView()
        self.topicView = topicView

        let dotView: UIView = UIView()
        self.dotView = dotView
        
        let label = UILabel()
        self.titleLabel = label
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = UIColor.white
        self.selectionStyle = .none

        self.contentView.addSubview(topicView)
        self.contentView.addSubview(dotView)
        self.contentView.addSubview(label)

        topicView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }

        let font = UIFont.systemFont(ofSize: 16)
        dotView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalTo(label.snp.top).offset(font.lineHeight/2)
            $0.width.height.equalTo(6)
        }

        label.snp.makeConstraints {
            $0.top.equalTo(topicView.snp.bottom)
            $0.bottom.equalToSuperview().offset(-4)
            $0.leading.equalTo(dotView.snp.trailing).offset(5)
            $0.trailing.equalTo(topicView)
        }

        dotView.backgroundColor = UIColor.lightGray
        dotView.layer.cornerRadius = 3
        
        label.numberOfLines = 0

        label.font = font
        label.textColor = UIColor.darkText
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var cellViewModel: Any? {
        didSet {
            guard let cellViewModel = cellViewModel as? UserProfileDepartmentCellViewModel else {
                return
            }
            titleLabel.text = cellViewModel.path
            topicView.label.text = cellViewModel.topic
            if cellViewModel.isFirstOffset {
                self.titleLabel.snp.updateConstraints {
                    $0.top.equalTo(topicView.snp.bottom).offset(2)
                    $0.bottom.equalToSuperview().offset(-4)
                }
            } else {
                self.titleLabel.snp.updateConstraints {
                    $0.top.equalTo(topicView.snp.bottom)
                    $0.bottom.equalToSuperview().offset(-4)
                }
                if cellViewModel.isLastOffset {
                    self.titleLabel.snp.updateConstraints {
                        $0.bottom.equalToSuperview().offset(-12)
                    }
                }
            }
        }
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension String{
    //MARK:获得文本内容高度
    func stringHeightWith(fontSize: CGFloat,width: CGFloat, lineSpace: CGFloat) -> CGFloat {
        let font = UIFont.systemFont(ofSize: fontSize)
        //let size = CGSizeMake(width,CGFloat.max)
        let size = CGSize(width: width, height: CGFloat(MAXFLOAT))
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpace
        paragraphStyle.lineBreakMode = .byWordWrapping;
        let attributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: paragraphStyle.copy()]
        let text = self as NSString
        let rect = text.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context:nil)
        return rect.size.height
    }
}
