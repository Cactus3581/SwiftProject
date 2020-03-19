//
//  UserProfileSectionHeaderView.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/12.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit



class UserProfileSectionHeaderView: UITableViewHeaderFooterView,UserProfileSectionViewProtocol {

    let button: UIButton?

    override init(reuseIdentifier: String?) {

        let button: UIButton = UIButton()
        self.button = button

        super.init(reuseIdentifier: reuseIdentifier)

        self.contentView.backgroundColor = UIColor.green

        self.contentView.addSubview(button)
        button.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-10)
        }
        button.setTitleColor(UIColor.white,for: .normal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var sessionViewModel: UserProfileViewModelProtocol? {
        didSet {
            guard let sectionViewModel = self.sessionViewModel as? UserProfileTextViewModelProtocol else {
                return
            }
            button?.setTitle(sectionViewModel.headerText, for: .normal)
        }
    }

    static var identifier: String {
        return String(describing: self)
    }
}
