//
//  MVVMListCourseTableViewCell.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/11.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class MVVMListCourseTableViewCell: UITableViewCell, MVVMListSecTableViewCellProtocol {

    let titleLabel: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {

        let label: UILabel = UILabel()
        self.titleLabel = label

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.contentView.backgroundColor = UIColor.white

        self.contentView.addSubview(label)
        label.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
        label.textColor = UIColor.red
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var cellViewModel: MVVMListSecCellViewModelProtocol? {
        didSet {
            guard let cellViewModel = cellViewModel as? MVVMListCourseCellViewModel else {
                return
            }
            // 赋值
            titleLabel?.text = cellViewModel.model?.courseName
        }
    }

    static var identifier: String {
        return String(describing: self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
