//
//  TestTableViewController.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2021/6/30.
//  Copyright © 2021 cactus. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxDataSources

enum OperationType: Int {
    case insert = 0, update, delete
}

/// Diff需要的数据源
struct SectionHolder: AnimatableSectionModelType {
    var identity: String = "Test"
    var items: [Int] = []
    init() {}
    init(original: SectionHolder, items: [Int]) {
        self = original
        self.items = items
    }
}

class TestTableViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    private let tableView = UITableView(frame: CGRect.zero, style: .plain)
    var array = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        tableView.rowHeight = 50
        tableView.indicatorStyle = .black
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView()
        tableView.register(TableViewHeightCell.self, forCellReuseIdentifier: "cell")
        handleData()
    }

    // MARK: TableView协议方法
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? TableViewHeightCell {
            cell.label.text = "\(indexPath.row)"
            return cell
        }
        return UITableViewCell()
    }

    // MARK: 处理数据
    func handleData() {
        let updateTimer = Timer(timeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            var array: [Int]?
            let operationType = self.randomOperationType()
            switch operationType {
            case .insert:
                array = self.insertCard()
            case .update:
                array = self.updateCard()
            case .delete:
                array = self.deleteCard()
            }
            if let array = array {
                var newSection = SectionHolder()
                newSection.items = array
                var oldSection = SectionHolder()
                oldSection.items = self.array
                self.diff(newSection: newSection, oldSection: oldSection)
            }
        }
        RunLoop.main.add(updateTimer, forMode: .common)
    }

    func updateCard() -> [Int]? {
        let index = self.randomIndex()
        guard index < array.count else { return nil }
        var array = self.array
        array[index] = randomItem()
        return array
    }

    func insertCard() -> [Int] {
        let index = self.randomIndex()
        let item = randomItem()
        var array = self.array
        array.insert(item, at: index)
        return array
    }

    func deleteCard() -> [Int]? {
        let index = self.randomIndex()
        guard index < self.array.count else { return nil }
        var array = self.array
        array.remove(at: index)
        return array
    }

    func randomIndex() -> Int {
        return Int(arc4random_uniform(UInt32(self.array.count)))
    }

    func randomOperationType() -> OperationType {
        return OperationType(rawValue: Int(arc4random_uniform(UInt32(3)))) ?? .insert
    }

    func randomItem() -> Int {
        return Int(arc4random_uniform(UInt32(100000)))
    }

    func randomTimesInPerUpdate() -> Int {
        return Int(arc4random_uniform(UInt32(20)))
    }

    // MARK: UI Diff
    func diff(newSection: SectionHolder, oldSection: SectionHolder) {
        do {
            let diffs = try Diff.differencesForSectionedView(initialSections: [oldSection], finalSections: [newSection])
            for diff in diffs {
                if !isDiffValid(diff: diff) {
                    // Diff非法，直接reload
                    self.array = diff.finalSections.first?.items ?? []
                    self.tableView.reloadData()
                } else {
                    self.array = diff.finalSections.first?.items ?? []
                    let updateBlock = {
                        let deleteRows = diff.deletedItems.map { IndexPath(item: $0.itemIndex, section: $0.sectionIndex) }
                        let insertRows = diff.insertedItems.map { IndexPath(item: $0.itemIndex, section: $0.sectionIndex) }
                        let reloadRows = diff.updatedItems.map { IndexPath(item: $0.itemIndex, section: $0.sectionIndex) }
                        print("Test-9: deleteRows: \(deleteRows.count), insertRows: \(insertRows.count), reloadRows: \(reloadRows.count), movedItems: \(diff.movedItems.count)")
                        self.tableView.deleteRows(at: diff.deletedItems.map { IndexPath(item: $0.itemIndex, section: $0.sectionIndex) }, with: .none)
                        self.tableView.insertRows(at: diff.insertedItems.map { IndexPath(item: $0.itemIndex, section: $0.sectionIndex) }, with: .none)
                        self.tableView.reloadRows(at: diff.updatedItems.map { IndexPath(item: $0.itemIndex, section: $0.sectionIndex) }, with: .none)
                        diff.movedItems.forEach { (from, to) in
                            self.tableView.moveRow(at: IndexPath(item: from.itemIndex, section: from.sectionIndex), to: IndexPath(item: to.itemIndex, section: to.sectionIndex))
                        }
                    }
                    print("Test-7:performWithoutAnimation")
                    UIView.performWithoutAnimation {
                        print("Test-8:performWithoutAnimation")
                        self.tableView.performBatchUpdates(updateBlock, completion: nil)
                    }
                }
            }
        } catch let error {
            print("Diff Error")
            self.tableView.reloadData() // 容错
        }
    }

    private func isDiffValid(diff: Changeset<SectionHolder>) -> Bool {
        guard diff.finalSections.count == self.tableView.numberOfSections else { return false }
        for index in 0..<diff.finalSections.count {
            let change = diff.insertedItems.count - diff.deletedItems.count
            if diff.finalSections[index].items.count != self.tableView.numberOfRows(inSection: index) + change {
                print("Invalid update: \(diff) -> \(self.tableView.numberOfRows(inSection: index))")
                return false
            }
        }
        return true
    }
}
