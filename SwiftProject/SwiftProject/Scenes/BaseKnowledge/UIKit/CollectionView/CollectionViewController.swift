//
//  CollectionViewController.swift
//  SwiftProject
//
//  Created by Ryan on 2020/8/20.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit
import SnapKit

class CollectionViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    var dataSource = ["1"]
    var collectionview: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 50, height: 50)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.collectionview = collectionview
        collectionview.delegate = self
        collectionview.dataSource = self
        self.view.addSubview(collectionview)
        collectionview.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        collectionview.register(CollectionViewCell.self, forCellWithReuseIdentifier: "cell")

        let item = UIBarButtonItem(title:"show",
                                   style:.plain,
                                   target:self,
                                   action:#selector(click))
        self.navigationItem.rightBarButtonItem = item
    }

    @objc
    func click() {
        dataSource.append("1")
        UIView.performWithoutAnimation {
            self.collectionview.performBatchUpdates {
                let indexPath = IndexPath(item: dataSource.count-1, section: 0)
                self.collectionview.insertItems(at: [indexPath])
            } completion: { _ in

            }
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CollectionViewCell else { return UICollectionViewCell() }
        cell.label.text = dataSource[indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dataSource.removeLast()
        UIView.performWithoutAnimation {
            collectionView.performBatchUpdates({
                collectionView.deleteItems(at: [indexPath])
            }, completion: nil)
        }
    }
}
