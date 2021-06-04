//
//  TableViewHeightCell.swift
//  SwiftProject
//
//  Created by Ryan on 2020/10/15.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class TableViewHeightCell: UITableViewCell {

    let label = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        //关闭点击效果
        self.selectionStyle = .none

        label.text = "Pano"
        label.backgroundColor = .red
        self.contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        print("testSelected: selected: \(selected)")
        setColorState(selected)
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        print("testSelected: highlighted: \(highlighted)")
        setColorState(highlighted)
    }

    func setColorState(_ isState: Bool) {
        if isState {
            self.contentView.backgroundColor = .green
        } else {
            self.contentView.backgroundColor = .white
        }
    }
}
