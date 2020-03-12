//
//  MVVMListButtonTableViewCell.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/11.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class MVVMListButtonTableViewCell: UITableViewCell,MVVMListTableViewCellProtocol {

    let button: UIButton?

    var cellViewModel: MVVMListCellViewModelProtocol? {
        didSet {
            guard let cellViewModel = cellViewModel as? MVVMListButtonTableViewCellViewModel else {
                return
            }
            // 赋值
            button?.setTitle(cellViewModel.buttonTitle, for: .normal)
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
            $0.edges.equalToSuperview().inset(10)
        }
        button.backgroundColor = UIColor.blue
        button.addTarget(self, action: #selector(click), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func click(){
        guard let cellViewModel = cellViewModel as? MVVMListButtonTableViewCellViewModel else {
            return
        }

        cellViewModel.click()
    }

    func jump(){
        guard let cellViewModel = cellViewModel as? MVVMListButtonTableViewCellViewModel else {
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
