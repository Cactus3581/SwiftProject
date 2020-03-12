//
//  BPImageTableViewCell.swift
//  SwiftProject
//
//  Created by ryan on 2020/1/15.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class BPImageTableViewCell: UITableViewCell, BPTableCellProtocol {

    @IBOutlet weak var coverImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    var cellVM: BPCellViewModelProtocol? {
        didSet {
            guard let cellVM1 = cellVM as? BPImageViewModel else {
                return
            }

            guard let imageUrl = cellVM1.imageUrl else {
                return
            }
            coverImageView.image = UIImage.init(named: imageUrl)
        }
    }

    func setData(data: BPCellViewModelProtocol) {
        cellVM = data
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
