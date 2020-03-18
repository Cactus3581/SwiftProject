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
    let coverImageView: UIImageView?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {

        let coverImageView: UIImageView = UIImageView()
        self.coverImageView = coverImageView

        let label: UILabel = UILabel()
        self.titleLabel = label

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.contentView.backgroundColor = UIColor.white

        self.contentView.addSubview(coverImageView)
        coverImageView.snp.makeConstraints {
            $0.width.height.equalTo(80)
            $0.leading.equalToSuperview().offset(15)
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-10)
        }

        coverImageView.layer.cornerRadius = 40
        coverImageView.clipsToBounds = true
        coverImageView.contentMode = .scaleAspectFit
        coverImageView.backgroundColor = UIColor.lightGray

        self.contentView.addSubview(label)
        label.snp.makeConstraints {
            $0.leading.equalTo(coverImageView.snp.trailing).offset(50)
            $0.centerY.equalToSuperview()
        }
        label.textColor = UIColor.red
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var cellViewModel: Any? {
        didSet {
            guard let cellViewModel = cellViewModel as? MVVMListCourseCellViewModelProtocol else {
                return
            }
            // 赋值
            titleLabel?.text = cellViewModel.title
            //coverImageView?.image = UIImage(named: item.pictureUrl)
        }
    }

    static var identifier: String {
        return String(describing: self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        coverImageView?.image = nil
    }

    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}
