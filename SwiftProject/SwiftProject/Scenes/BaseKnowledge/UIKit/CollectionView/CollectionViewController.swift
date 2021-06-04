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

//    var dataSource = ["1","2","3"]
    var dataSource = ["1"]
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 50, height: 50)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionview.delegate = self
        collectionview.dataSource = self
        self.view.addSubview(collectionview)
        collectionview.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        collectionview.register(CollectionViewCell.self, forCellWithReuseIdentifier: "cell")



        let dict1 = ["name": "Swift", "version": "5.3"]
        let dict2 = ["platform": "iOS"]
        let total = dict1.merging(dict2) { (first, _) -> String in
            return first
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
//        dataSource[2] = "4"
//        dataSource.remove(at: 0)
//        dataSource.remove(at: 0)
//        UIView.performWithoutAnimation {
////            collectionView.performBatchUpdates({
//                collectionView.reloadItems(at: [IndexPath(item: 2, section: 0)])
//                collectionView.deleteItems(at: [IndexPath(item: 0, section: 0),IndexPath(item: 1, section: 0)])
////            }, completion: nil)
//
//        }

        // {"former count":"1","current count":"3","changeset":"delete 0,reload 1,insert 2"}        dataSource[2] = "4"

        dataSource.insert("2", at: 1)
        dataSource.insert("3", at: 2)
//        dataSource[1] = "5"
        UIView.performWithoutAnimation {
            collectionView.performBatchUpdates({
                //collectionView.deleteItems(at: [IndexPath(item: 0, section: 0),IndexPath(item: 1, section: 0)])
//                collectionView.reloadItems(at: [IndexPath(item: 0, section: 0)])
                collectionView.insertItems(at: [IndexPath(item: 1, section: 0),IndexPath(item: 2, section: 0)])
            }, completion: nil)
        }

//        UIView.performWithoutAnimation {
//                //collectionView.deleteItems(at: [IndexPath(item: 0, section: 0),IndexPath(item: 1, section: 0)])
//                collectionView.reloadItems(at: [IndexPath(item: 0, section: 0)])
////                collectionView.insertItems(at: [IndexPath(item: 0, section: 0),IndexPath(item: 2, section: 0)])
//        }
    }

}
