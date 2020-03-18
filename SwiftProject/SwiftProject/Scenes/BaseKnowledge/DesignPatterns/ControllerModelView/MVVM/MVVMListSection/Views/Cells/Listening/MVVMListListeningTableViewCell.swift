//
//  MVVMListListeningTableViewCell.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/11.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class MVVMListListeningTableViewCell: UITableViewCell,MVVMListSecTableViewCellProtocol {

    let button: UIButton?

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

        button.setTitleColor(UIColor.blue,for: .normal)
        button.addTarget(self, action: #selector(click), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var cellViewModel: Any? {
        didSet {
            guard let cellViewModel = cellViewModel as? MVVMListListeningCellViewModel else {
                return
            }
            // 赋值
            button?.setTitle(cellViewModel.model?.ListeningName, for: .normal)
        }
    }

    @objc func click(){
        guard let cellViewModel = cellViewModel as? MVVMListListeningCellViewModel else {
            return
        }

        cellViewModel.click()
    }

    func jump(){
        guard let cellViewModel = cellViewModel as? MVVMListTextListeningSectionViewModel else {
            return
        }

        cellViewModel.headerJump()
    }

    static var identifier: String {
        return String(describing: self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
