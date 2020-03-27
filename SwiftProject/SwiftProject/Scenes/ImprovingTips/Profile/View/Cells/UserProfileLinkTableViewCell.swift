//
//  UserProfileLinkTableViewCell.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/24.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class UserProfileLinkTableViewCell: UITableViewCell, UserProfileTableViewCellProtocol {

    weak var titleLabel: UILabel!
    weak var arrowImageView: UIImageView!
    weak var lineView: UIView!
    var indexPath: IndexPath?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {

        let label: UILabel = UILabel()
        self.titleLabel = label

        let arrowImageView = UIImageView()
        self.arrowImageView = arrowImageView

        let lineView: UIView = UIView()
        self.lineView = lineView

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.contentView.backgroundColor = UIColor.white
        self.contentView.addSubview(arrowImageView)
        self.contentView.addSubview(label)
        self.contentView.addSubview(lineView)

        label.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-12)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalTo(arrowImageView.snp.leading).offset(-10)
        }
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.darkText

        arrowImageView.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalTo(label)
        }
        arrowImageView.image = UIImage(named: "icon_back")

        lineView.backgroundColor = UIColor.lightGray
        lineView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1/UIScreen.main.scale)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var cellViewModel: Any? {
        didSet {
            guard let cellViewModel = cellViewModel as? UserProfileLinkCellViewModel else {
                return
            }

            if let linkTitle = cellViewModel.model?.linkTitle, !linkTitle.isEmpty {
                // 有section标题，即有linktitle
                titleLabel.text = cellViewModel.model?.linkTitle
                self.titleLabel.snp.updateConstraints {
                    $0.top.equalToSuperview()
                    $0.bottom.equalToSuperview().offset(-12)
                }
            } else {
                titleLabel.text = cellViewModel.model?.key
                // 无section标题，即无linktitle
                self.titleLabel.snp.updateConstraints {
                    $0.top.equalToSuperview().offset(23)
                    $0.bottom.equalToSuperview().offset(-23)
                }
            }

            if let url = cellViewModel.model?.url, !url.isEmpty {
                self.arrowImageView.isHidden = false
            } else {
                self.arrowImageView.isHidden = true
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
