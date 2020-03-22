//
//  UserProfileViewModel.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/11.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class UserProfileViewModel: NSObject {

    var model: UserProfileModel?
    var array:Array<UserProfileSessionViewModelProtocol> = [UserProfileSessionViewModelProtocol]()
    var ctaList:Array<UserProfileCTAItemViewModel> = [UserProfileCTAItemViewModel]()

    typealias DataResultHandler = () -> ()
    typealias TableviewCellConfig = (UITableView, NSIndexPath) -> (UITableViewCell)
    typealias ReloadSectionHandler = (Int) -> Void
    typealias ReloadCellHandler = (NSIndexPath) -> Void

    var reloadSectionHandler: ReloadSectionHandler?
    var reloadCellHandler: ReloadCellHandler?
    var tableviewCellConfig: TableviewCellConfig?

    override init() {
        super.init()
    }

    //MARK: 数据请求 + 工厂类初始化sessionViewModel + 将数据源array通过闭包抛给vc中的tableview去做刷新 + 监听事件
    func requestData(result: DataResultHandler?)  {

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

        if let result = result {
            result()
            observe()
        }
    }

    //MARK: 有些事件需要依赖tableview，比如展开更多，所以需要监听list变化，然后将事件抛给 tableview 去做刷新
    func observe() {
        for sessionViewModel in self.array {
            guard let observableObject = sessionViewModel as? NSObject else {
                continue
            }
            //监听list的变化
            observableObject.addObserver(self, forKeyPath: "list", options: [.new], context:nil)
            for cellViewModel in sessionViewModel.list ?? [] {
                guard let cellObject = cellViewModel as? NSObject else {
                    continue
                }
                if cellObject is UserProfilePhoneCellViewModel {
                    //cellObject.addObserver(self, forKeyPath: "model.isShow", options: [.new], context:nil)
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

    func configTableviewCell(config: @escaping TableviewCellConfig) {
        self.tableviewCellConfig = config
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
        if let config = self.tableviewCellConfig {
            return config(tableView, indexPath as NSIndexPath)
        }
        return UITableViewCell()
    }
}
