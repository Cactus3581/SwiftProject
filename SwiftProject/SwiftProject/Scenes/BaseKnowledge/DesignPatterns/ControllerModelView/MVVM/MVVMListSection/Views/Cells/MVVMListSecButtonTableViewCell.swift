//
//  MVVMListSecButtonTableViewCell.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/11.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class MVVMListSecButtonTableViewCell: UITableViewCell,MVVMListSecTableViewCellProtocol {

    let button: UIButton?

    var cellViewModel: MVVMListSecCellViewModelProtocol? {
        didSet {
            guard let cellViewModel = cellViewModel as? MVVMListSecButtonCellViewModel else {
                return
            }
            // 赋值
            button?.setTitle(cellViewModel.model?.buttonTitle, for: .normal)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {

        let button: UIButton = UIButton()
        self.button = button

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.contentView.backgroundColor = UIColor.white

        self.contentView.addSubview(button)
        button.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.top.bottom.equalToSuperview()
        }

        button.setTitleColor(UIColor.red,for: .normal)
        button.addTarget(self, action: #selector(click), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func click(){
        guard let cellViewModel = cellViewModel as? MVVMListSecButtonCellViewModel else {
            return
        }

        cellViewModel.click()
    }

    func jump(){
        guard let cellViewModel = cellViewModel as? MVVMListButtonSectionViewModel else {
            return
        }

        cellViewModel.jump()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    static var identifier: String {
        return String(describing: self)
    }
}
