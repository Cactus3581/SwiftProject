//
//  UserProfileUserStatusTableViewCell.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/25.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class UserProfileUserStatusTableViewCell: UITableViewCell, UserProfileTableViewCellProtocol {

    weak var label: UILabel!
    weak var arrowImageView: UIImageView!
    weak var lineView: UIView!
    var indexPath: IndexPath?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {

        let label: UILabel = UILabel()
        self.label = label

        let arrowImageView = UIImageView()
        self.arrowImageView = arrowImageView

        let lineView: UIView = UIView()
        self.lineView = lineView
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.contentView.backgroundColor = UIColor.white

        self.contentView.addSubview(label)
        label.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-12)
        }
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.darkText

        self.contentView.addSubview(arrowImageView)
        arrowImageView.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalTo(label)
        }
        
        self.contentView.addSubview(lineView)
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
            guard let cellViewModel = cellViewModel as? UserProfileUserStatusCellViewModel else {
                return
            }
            label.text = cellViewModel.model?.statusInfo
        }
    }

    static var identifier: String {
        return String(describing: self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
