//
//  UserProfileViewModel.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/11.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class UserProfileViewModel: NSObject {

    var array:Array<UserProfileSessionViewModelProtocol> = [UserProfileSessionViewModelProtocol]()
    var ctaList:Array<UserProfileCTAItemViewModel> = [UserProfileCTAItemViewModel]()
    typealias success = () -> ()
    typealias tableviewCellConfig = (UITableView, NSIndexPath) -> (UITableViewCell)
    typealias reloadSection = (Int) -> Void
    typealias reloadCell = (NSIndexPath) -> Void

    var reloadSectionHandler: reloadSection?
    var reloadCellHandler: reloadCell?

    var tableviewCellConfig1: tableviewCellConfig?
    var model: UserProfileModel?

    override init() {
        super.init()
    }

    func requestData(success: success?)  {

        let jsonName = "UserProfileDict"

        guard let data = getDataFromFile(jsonName), let json = jsonSerial(data) as? [String: Any] else  {
            return
        }

        guard let model = UserProfileModel.deserialize(from: json) else {
            return
        }

        self.model = model
        if let data1 = UserProfileFactory.createSessionViewModelByDict(data: model) {
            array = data1
        }

        for ctaItemModel in model.ctaList ?? [] {
            let viewModel = UserProfileCTAItemViewModel()
            viewModel.model = ctaItemModel
            ctaList.append(viewModel)
        }

        if let success = success {
            success()
            kvo()
        }
    }

    func kvo() {
        //监听list的变化
        for sessionViewModel in self.array {
            guard let observableObject = sessionViewModel as? NSObject else {
                continue
            }
            observableObject.addObserver(self, forKeyPath: "list", options: [.new, .old], context:nil)
            for cellViewModel in sessionViewModel.list ?? [] {
                guard let cellObject = cellViewModel as? NSObject else {
                    continue
                }
                if cellObject is UserProfilePhoneCellViewModel {
                    cellObject.addObserver(self, forKeyPath: "model.isShow", options: [.new, .old], context:nil)
                }
            }
        }
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "list" {
            let obj = object as? UserProfileDepartmentSessionViewModel
            if let obj1 = obj, let section = obj1.section {
                let sec1 = section as? Int
                if let sec2 = sec1 {
                    if let reloadSectionHandler1 = self.reloadSectionHandler {
                        reloadSectionHandler1(section)
                    }
                }
            }
        } else if keyPath == "model.isShow" {
            let obj = object as? UserProfilePhoneCellViewModel
            if let obj1 = obj, let indexPath = obj1.indexPath {
                let indexPath1 = indexPath as? NSIndexPath
                if let indexPath2 = indexPath1 {
                    if let reloadCellHandler1 = self.reloadCellHandler {
                        reloadCellHandler1(indexPath2)
                    }
                }
            }
        }
    }

    func configTableviewCell(config: @escaping tableviewCellConfig) {
        self.tableviewCellConfig1 = config
    }

    private func getDataFromFile(_ filename: String) -> Data? {
        @objc class TestClass: NSObject { }
        let bundle = Bundle(for: TestClass.self)
        if let path = bundle.path(forResource: filename, ofType: "json") {
            return (try? Data(contentsOf: URL(fileURLWithPath: path)))
        }
        return nil
    }

    private func jsonSerial(_ data: Data) -> Any? {
        return try? JSONSerialization.jsonObject(with: data, options: [])
    }


    func headerClick(){
        print("页眉 click")
    }

    func footerJump(){
        print("页脚 jump")
    }
}

extension UserProfileViewModel: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return array.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section:UserProfileSessionViewModelProtocol = array[section]
        return section.list?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let config = self.tableviewCellConfig1 {
            return config(tableView, indexPath as NSIndexPath)
        }
        return UITableViewCell()
    }
}
