//
//  UserProfileSectionFooterView.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2020/3/19.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class UserProfileSectionFooterView: UITableViewHeaderFooterView,UserProfileSectionViewProtocol {

    let button: UIButton?
    var section: Int?

    override init(reuseIdentifier: String?) {

        let button: UIButton = UIButton()
        self.button = button

        super.init(reuseIdentifier: reuseIdentifier)

        self.contentView.backgroundColor = UIColor.white

        self.contentView.addSubview(button)
        button.snp.makeConstraints {
            $0.leading.equalTo(32)
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-10)
        }
        button.setTitleColor(UIColor.blue,for: .normal)
        button.addTarget(self, action: #selector(footerClick), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var sessionViewModel: UserProfileSessionViewModelProtocol? {
        didSet {
            guard let sectionViewModel = self.sessionViewModel as? UserProfileDepartmentSessionViewModelProtocol else {
                return
            }
            button?.setTitle(sectionViewModel.footerText, for: .normal)
        }
    }

    @objc func footerClick() {
        guard let sectionViewModel1 = self.sessionViewModel as? UserProfileDepartmentSessionViewModelProtocol else {
             return
         }

        sectionViewModel1.reloadData(section: self.section!)
    }

    static var identifier: String {
        return String(describing: self)
    }
}