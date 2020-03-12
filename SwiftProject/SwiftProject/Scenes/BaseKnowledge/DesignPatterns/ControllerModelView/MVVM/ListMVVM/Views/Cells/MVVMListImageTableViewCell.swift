//
//  MVVMListImageTableViewCell.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/11.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class MVVMListImageTableViewCell: UITableViewCell, MVVMListTableViewCellProtocol {

    let avatarImageView: UIImageView?

    var cellViewModel: MVVMListCellViewModelProtocol? {
        didSet {
            guard let cellViewModel = cellViewModel as? MVVMListImageTableViewCellViewModel else {
                return
            }
            // 赋值
            avatarImageView?.image = UIImage.init(named: cellViewModel.imageUrl ?? "")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {

        let avatarImageView:UIImageView  = UIImageView()
        self.avatarImageView = avatarImageView

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.contentView.backgroundColor = UIColor.white

        self.contentView.addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    static var identifier: String {
        return String(describing: self)
    }
}
