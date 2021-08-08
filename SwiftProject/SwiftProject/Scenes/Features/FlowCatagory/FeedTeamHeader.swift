//
//  FeedTeamHeader.swift
//  LarkFeed
//
//  Created by 夏汝震 on 2021/7/13.
//

import Foundation
import UIKit

protocol FeedTeamHeaderDelegate: AnyObject {
    func expandAction(_ section: Int)
}

class FeedTeamHeader: UITableViewHeaderFooterView {
    static var identifier: String = "FeedTeamHeader"
    weak var delegate: FeedTeamHeaderDelegate?
    let arrowImageView = UIImageView()
    var section = 0
    var model = SubListVC3Model()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(expandAction))
        self.addGestureRecognizer(tapGes)
        arrowImageView.image = UIImage.init(named: "feed_team_expand")
        addSubview(arrowImageView)
        arrowImageView.snp.makeConstraints { (make) in
            make.size.equalTo(12)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }
    }

    func set(_ model: SubListVC3Model, _ section: Int) {
        self.section = section
        self.model = model
        self.arrowImageView.transform = CGAffineTransform(rotationAngle: getRotation(isWillExpanded: model.isExpanded).1)
    }

    private func getRotation(isWillExpanded: Bool) -> (CGFloat, CGFloat) {
        var originRotation: CGFloat
        var targetRotation: CGFloat
        if isWillExpanded {
            // 将要展开
            originRotation = 1 * -(.pi / 2)
            targetRotation = 0

        } else {
            // 将要收起
            originRotation = 0
            targetRotation = 1 * -(.pi / 2)
        }
        return (originRotation, targetRotation)
    }

        
    @objc
    private func expandAction() {
        let rotation = getRotation(isWillExpanded: !model.isExpanded)
        let originRotation = rotation.0
        let targetRotation = rotation.1
//        self.arrowImageView.transform = CGAffineTransform(rotationAngle: originRotation)
        UIView.animate(withDuration: 0.25, animations: {
            self.arrowImageView.transform = CGAffineTransform(rotationAngle: targetRotation)
        }, completion: { _ in
        })
        self.delegate?.expandAction(self.section)
    }
}
