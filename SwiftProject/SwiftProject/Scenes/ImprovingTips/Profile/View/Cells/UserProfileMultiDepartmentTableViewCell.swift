//
//  UserProfileDepartmentTableViewCell.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/11.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class UserProfileMultiDepartmentTableViewCell: UITableViewCell, UserProfileTableViewCellProtocol {
    
    let titleLabel: UILabel?
    let lineView: UIView?
    let dotView: UIView?
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        let dotView: UIView = UIView()
        self.dotView = dotView
        
        let label: UILabel = UILabel()
        self.titleLabel = label
        
        let lineView: UIView = UIView()
        self.lineView = lineView
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = UIColor.red
        
        self.contentView.addSubview(dotView)
        dotView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(6)
        }
        dotView.backgroundColor = UIColor.lightGray
        dotView.layer.cornerRadius = 3
        
        self.contentView.addSubview(label)
        label.numberOfLines = 3
        label.snp.makeConstraints {
            $0.leading.equalTo(dotView.snp.trailing).offset(16)
            $0.top.equalToSuperview().offset(23)
            $0.bottom.equalToSuperview().offset(-23)
        }
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.darkText
        
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
            guard let cellViewModel = cellViewModel as? UserProfileDepartmentCellViewModel else {
                return
            }
            titleLabel?.text = cellViewModel.path
        }
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
