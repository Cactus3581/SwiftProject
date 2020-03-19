//
//  MVVMListTableHeaderView.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/12.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class MVVMListTableHeaderView: UIView {

    let button: UIButton?
    let coverImageView: UIImageView?

    override init(frame: CGRect) {

        let button: UIButton = UIButton()
        self.button = button

        let coverImageView: UIImageView = UIImageView()
        self.coverImageView = coverImageView

        super.init(frame: frame)

        self.backgroundColor = UIColor.lightGray

        self.addSubview(coverImageView)
        coverImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        coverImageView.image = UIImage(named: "cactus_explicit")
        coverImageView.clipsToBounds = true
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.backgroundColor = UIColor.lightGray

        self.addSubview(button)
         button.snp.makeConstraints {
             $0.center.equalToSuperview()
         }
        button.setTitleColor(UIColor.white,for: .normal)
        button.addTarget(self, action: #selector(click), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var viewModel: MVVMListSecViewModel? {
        didSet {
            button?.setTitle(viewModel?.model?.header?.title, for: .normal)
        }
    }

    @objc func click(){
        self.viewModel?.headerClick()
    }
}
