//
//  SubListVC4.swift
//  UDCCatalog
//
//  Created by 夏汝震 on 2021/7/21.
//  Copyright © 2021 姚启灏. All rights reserved.
//

import Foundation
import UIKit

class SubListVC4: UIViewController {
    let arrowImageView = UIImageView()
    var isExpanded = true

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    func setupView() {
        self.view.backgroundColor = .white
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(expandAction))
        self.view.addGestureRecognizer(tapGes)
        arrowImageView.image = UIImage.init(named: "feed_team_expand")
        view.addSubview(arrowImageView)
        arrowImageView.snp.makeConstraints { (make) in
            make.size.equalTo(12)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }
    }

    @objc
    private func expandAction() {
        let originProcess = (isExpanded ? 0 : 1) as CGFloat
        isExpanded = !isExpanded
        let process = (isExpanded ? 0 : 1) as CGFloat
        let rotation = originProcess * -(.pi / 2)
        let targetRotation = process * -(.pi / 2)
        self.arrowImageView.transform = CGAffineTransform(rotationAngle: rotation)
        UIView.animate(withDuration: 0.25, animations: {
            self.arrowImageView.transform = CGAffineTransform(rotationAngle: targetRotation)
        })
    }
}
