//
//  UserProfileSectionHeaderView.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/12.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit



class UserProfileSectionHeaderView: UITableViewHeaderFooterView,UserProfileSectionViewProtocol {
    
    let label: UILabel?
    var section: Int?
    
    override init(reuseIdentifier: String?) {
        
        let label: UILabel = UILabel()
        self.label = label
        
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = UIColor.green
        
        self.contentView.addSubview(label)
        label.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalToSuperview().offset(12)
            $0.bottom.equalToSuperview().offset(-2)
        }
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 14)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var sessionViewModel: UserProfileSessionViewModelProtocol? {
        didSet {
            guard let sectionViewModel = self.sessionViewModel else {
                return
            }
            label?.text = sectionViewModel.headerText
        }
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}
