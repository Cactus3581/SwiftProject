//
//  BPGesSlidePopupContentView.swift
//  SwiftProject
//
//  Created by Ryan on 2021/6/4.
//  Copyright © 2021 cactus. All rights reserved.
//

import Foundation

class BPGesSlidePopupContentView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 20
        flowLayout.itemSize = CGSize(width: 100, height: 100)
        flowLayout.scrollDirection = .vertical

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.bounces = true
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = true
        collectionView.backgroundColor = .red
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()

    private var dataSource: [String] = []

    init(frame: CGRect, dataSource: [String]) {
        self.dataSource = dataSource
        super.init(frame: frame)
        self.initSubViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateData(_ dataSource: [String]) {
        self.dataSource = dataSource
        self.collectionView.reloadData()
    }

    private func initSubViews() {
        let headerView = UIView()
        headerView.backgroundColor = .green
        self.addSubview(headerView)
        self.addSubview(collectionView)
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self)
            make.height.equalTo(80)
        }

        collectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(self)
            make.top.equalTo(headerView.snp.bottom)
        }

        let editButton = UIButton()
        headerView.addSubview(editButton)
        editButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16)
            make.size.equalTo(30)
        }
        editButton.setTitle("编辑", for: .normal)
        editButton.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
    }

    @objc
    func buttonAction(_ button: UIButton) {
        print("buttonActionbuttonAction")
    }

    // MARK - 布局collectionview
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CollectionViewCell else { return UICollectionViewCell() }
        cell.label.text = "\(indexPath.row)"
        cell.backgroundColor = .green
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击了cell")
    }
}
