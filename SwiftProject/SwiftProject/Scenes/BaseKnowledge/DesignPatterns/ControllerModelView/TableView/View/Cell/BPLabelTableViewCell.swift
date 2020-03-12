//
//  BPLabelTableViewCell.swift
//  SwiftProject
//
//  Created by ryan on 2020/1/15.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class BPLabelTableViewCell: UITableViewCell, BPTableCellProtocol {
    @IBOutlet weak var tieleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    var cellVM: BPCellViewModelProtocol? {
        didSet {
            guard let cellVM1 = cellVM as? BPLabelViewModel else {
                return
            }

            guard let title = cellVM1.title else {
                return
            }
            tieleLabel.text = title
        }
    }

    func setData(data: BPCellViewModelProtocol) {
        cellVM = data
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
