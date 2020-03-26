//
//  ListTableViewCell.swift
//  SwiftProject
//
//  Created by Ryan on 2019/12/19.
//  Copyright © 2019 cactus. All rights reserved.
//

import UIKit
import SnapKit

private var cellIdentifier: String = "ListTableViewCell"

class ListTableViewCell: UITableViewCell {

    var model: ListModel?
    var _titleLabel: UILabel?
    var _detailLabel: UILabel?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initializeUI()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        initializeUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    class func cellWithTableView(_ tableView: UITableView, indexPath: IndexPath) -> Self {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        //let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,for: indexPath)
        if cell == nil {
            cell = ListTableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        return cell as! Self
    }

    // MARK: - initialize methods
    func initializeUI() {

        //self.selectionStyle = .none
        self.backgroundColor = UIColor.white

        let titleLabel: UILabel = UILabel()
        _titleLabel = titleLabel
        titleLabel.numberOfLines = 0
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(self).offset(10);
            make.top.equalTo(self).offset(10);
        }

        let detailLabel: UILabel = UILabel()
        _detailLabel = detailLabel
        self.contentView.addSubview(detailLabel)
        detailLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(titleLabel);
            make.top.equalTo(titleLabel.snp_bottomMargin).offset(2.5);
        }

        _titleLabel?.backgroundColor = UIColor.red
        _detailLabel?.backgroundColor = UIColor.green
    }

    func setModel(_ model: ListModel, indexPath: IndexPath) {

        self.model = model

        if model.subVc_array?.count ?? 0 > 0 {
            self.accessoryType = .disclosureIndicator
        } else {
            self.accessoryType = .none
        }

        if indexPath != nil {
            self.textLabel?.text = "\(indexPath.row+1). \(String(describing: model.title!))"
        } else {
            self.textLabel?.text = model.title!

        }

        if model.fileName?.count ?? 0 > 0 {
            self.textLabel?.textColor = UIColor.black
        } else {
            self.textLabel?.textColor = UIColor.lightGray
        }
    }
}
