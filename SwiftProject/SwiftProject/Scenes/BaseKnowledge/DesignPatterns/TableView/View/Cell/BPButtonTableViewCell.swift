//
//  BPButtonTableViewCell.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2020/1/15.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class BPButtonTableViewCell: UITableViewCell, BPTableCellProtocol  {

    @IBOutlet weak var button: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    var cellVM: BPCellViewModelProtocol? {
        didSet {
            guard let cellVM1 = cellVM as? BPButtonViewModel else {
                return
            }
            button.setTitle(cellVM1.jump, for: .normal)
        }
    }


    func setData(data: BPCellViewModelProtocol) {
        cellVM = data
    }
    
    @IBAction func action(_ sender: Any) {
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
