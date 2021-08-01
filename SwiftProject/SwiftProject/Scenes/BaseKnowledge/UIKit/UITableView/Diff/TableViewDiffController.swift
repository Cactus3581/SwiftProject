//
//  TableViewDiffController.swift
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
    case insert = 0, update, delete, exchange
}

class DiffModel: IdentifiableType, Equatable {
    public var identity: String {
        return name
    }

    var name: String = ""
    public static func == (lhs: DiffModel, rhs: DiffModel) -> Bool {
        return lhs === rhs
    }
}

/// Diff需要的数据源
struct SectionHolder: AnimatableSectionModelType {
    var identity: String = "Test"
    var items: [DiffModel] = []
    init() {}
    init(original: SectionHolder, items: [DiffModel]) {
        self = original
        self.items = items
    }
}

class TableViewDiffController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    private let tableView = UITableView(frame: CGRect.zero, style: .plain)
    var datasource = [DiffModel]()

    let originalMaxCount = 2000
    let timesInPerUpdate = 10

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        tableView.rowHeight = 50
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .singleLine
        tableView.indicatorStyle = .black
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        handleData()
    }

    // MARK: TableView协议方法
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") {
            cell.textLabel?.text = "\(datasource[indexPath.row].name)"
            return cell
        }
        return UITableViewCell()
    }

    // MARK: 处理数据
    func handleData() {
        for _ in 0...originalMaxCount {
            let model = DiffModel()
            model.name = randomText()
            datasource.append(model)
        }

        let updateTimer = Timer(timeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            var newArray: [DiffModel] = Array(self.datasource)
            for _ in 0...self.timesInPerUpdate {
                let operationType = self.randomOperationType()
                switch operationType {
                case .insert:
                    newArray = self.insertItem(newArray)
                case .delete:
                    newArray = self.deleteItem(newArray)
                case .update:
                    newArray = self.updateItem(newArray)
                case .exchange:
                    newArray = self.exchangeItem(newArray)
                }
            }

            var newSection = SectionHolder()
            newSection.items = newArray
            var oldSection = SectionHolder()
            let oldArray = self.datasource
            oldSection.items = oldArray
            let log = oldArray.count > newArray.count ? "delete": "insert"
            print("test-10-1: \(log), count: \(newArray.count - oldArray.count)")
            self.diff(newSection: newSection, oldSection: oldSection)
        }
        RunLoop.main.add(updateTimer, forMode: .common)
    }

    func updateItem(_ array: [DiffModel]) -> [DiffModel] {
        let index = self.randomIndex(array)
        guard index < array.count else { return array }
        let newArray = Array(array)
        let model = newArray[index]
        model.name = randomText()
        return newArray
    }

    func insertItem(_ array: [DiffModel]) -> [DiffModel] {
        let index = self.randomIndex(array)
        let item = randomItem()
        var newArray = Array(array)
        newArray.insert(item, at: index)
        return newArray
    }

    func deleteItem(_ array: [DiffModel]) -> [DiffModel] {
        let index = self.randomIndex(array)
        guard index < array.count else { return array }
        var newArray = Array(array)
        newArray.remove(at: index)
        return newArray
    }

    func exchangeItem(_ array: [DiffModel]) -> [DiffModel] {
        let index1 = self.randomIndex(array)
        let index2 = self.randomIndex(array)
        var newArray = Array(array)
        let model1 = newArray[index1]
        let model2 = newArray[index2]
        newArray[index1] = model2
        newArray[index2] = model1
        return newArray
    }

    func randomIndex(_ array: [DiffModel]) -> Int {
        return Int(Int.random(in: 0...array.count))
    }

    func randomOperationType() -> OperationType {
        let randomInt = Int.random(in: 0...3)
        return OperationType(rawValue: randomInt) ?? .insert
    }

    func mapping(operationType: OperationType) -> String {
        switch operationType {
        case .insert:
            return "insert"
        case .delete:
            return "delete"
        case .update:
            return "update"
        case .exchange:
            return "exchange"
        }
    }

    func randomItem() -> DiffModel {
        let model = DiffModel()
        model.name = randomText()
        return model
    }

    func randomText() -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let text = String((0..<100).map{ _ in letters.randomElement()! })
        return text
    }

    // MARK: UI Diff
    func diff(newSection: SectionHolder, oldSection: SectionHolder) {
        do {
            let diffs = try Diff.differencesForSectionedView(initialSections: [oldSection], finalSections: [newSection])
            for diff in diffs {
                if !isDiffValid(diff: diff) {
                    // Diff非法，直接reload
                    print("test-1: Diff非法，直接reload")
                    self.datasource = diff.finalSections.first?.items ?? []
                    self.tableView.reloadData()
                } else {
                    self.datasource = diff.finalSections.first?.items ?? []
                    let updateBlock = {
                        let deleteRows = diff.deletedItems.map { IndexPath(item: $0.itemIndex, section: $0.sectionIndex) }
                        let insertRows = diff.insertedItems.map { IndexPath(item: $0.itemIndex, section: $0.sectionIndex) }
                        let reloadRows = diff.updatedItems.map { IndexPath(item: $0.itemIndex, section: $0.sectionIndex) }
                        print("test-10-2: deleteRows: \(deleteRows.count), insertRows: \(insertRows.count), reloadRows: \(reloadRows.count), movedItems: \(diff.movedItems.count)")
                        self.tableView.deleteRows(at: diff.deletedItems.map { IndexPath(item: $0.itemIndex, section: $0.sectionIndex) }, with: .none)
                        self.tableView.insertRows(at: diff.insertedItems.map { IndexPath(item: $0.itemIndex, section: $0.sectionIndex) }, with: .none)
                        self.tableView.reloadRows(at: diff.updatedItems.map { IndexPath(item: $0.itemIndex, section: $0.sectionIndex) }, with: .none)
                        diff.movedItems.forEach { (from, to) in
                            self.tableView.moveRow(at: IndexPath(item: from.itemIndex, section: from.sectionIndex), to: IndexPath(item: to.itemIndex, section: to.sectionIndex))
                        }
                    }
                    UIView.performWithoutAnimation {
                        self.tableView.performBatchUpdates(updateBlock, completion: nil)
                    }
                }
            }
        } catch let error {
            print("test-5: Diff Error \(error)")
            self.tableView.reloadData() // 容错
        }
    }

    private func isDiffValid(diff: Changeset<SectionHolder>) -> Bool {
        guard diff.finalSections.count == self.tableView.numberOfSections else { return false }
        for index in 0..<diff.finalSections.count {
            let change = diff.insertedItems.count - diff.deletedItems.count
            if diff.finalSections[index].items.count != self.tableView.numberOfRows(inSection: index) + change {
                print("test-6: Invalid update: \(diff) -> \(self.tableView.numberOfRows(inSection: index))")
                return false
            }
        }
        return true
    }
}
