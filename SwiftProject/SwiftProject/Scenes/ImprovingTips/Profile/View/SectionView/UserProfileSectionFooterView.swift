//
//  UserProfileSectionFooterView.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/19.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class UserProfileSectionFooterView: UITableViewHeaderFooterView,UserProfileSectionViewProtocol {
    
    weak var button: UIButton!
    var section: Int?
    
    override init(reuseIdentifier: String?) {
        
        let button: UIButton = UIButton()
        self.button = button
        
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = UIColor.white
        
        self.contentView.addSubview(button)
        button.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(32)
            $0.centerY.equalToSuperview()
            //$0.top.equalToSuperview().offset(10)
            //$0.bottom.equalToSuperview().offset(-16)
        }
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(UIColor.blue,for: .normal)
        button.addTarget(self, action: #selector(footerClick), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var sessionViewModel: UserProfileSessionViewModelProtocol? {
        didSet {
            guard let sectionViewModel = self.sessionViewModel as? UserProfileDepartmentSessionViewModel else {
                return
            }
            button.setTitle(sectionViewModel.footerText, for: .normal)
        }
    }
    
    @objc func footerClick() {
        guard let sectionViewModel1 = self.sessionViewModel as? UserProfileDepartmentSessionViewModel else {
            return
        }
        sectionViewModel1.reloadData(section: self.section!)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}
