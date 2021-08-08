//
//  FlowCatagoryView.swift
//  SwiftProject
//
//  Created by Ryan on 2021/7/5.
//  Copyright © 2021 Ryan. All rights reserved.
//

import Foundation

protocol FlowCatagoryViewLayoutDelegate: AnyObject {
    func flowCatagoryView(isShow: Bool)
    func flowCatagoryView(isSupportCeiling: Bool)
}

class FlowCatagoryView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    let flowCatagoryViewHeight: CGFloat = 40

    init() {
        super.init(frame: .zero)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .yellow
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    var titles = [String]() {
        didSet {
            collectionView.reloadData()
        }
    }

    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        flowLayout.minimumInteritemSpacing = 20
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.bounces = true
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .green
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()

    // MARK - 布局collectionview
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.titles.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CollectionViewCell else { return UICollectionViewCell() }
        cell.label.text = titles[indexPath.row]
        cell.label.textAlignment = .center
        cell.backgroundColor = .green
        return cell
    }
}
