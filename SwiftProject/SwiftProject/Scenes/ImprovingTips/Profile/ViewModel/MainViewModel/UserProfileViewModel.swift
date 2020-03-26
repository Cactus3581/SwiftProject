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
    var ctaList:Array<UserProfileCTAItemViewModelProtocol> = [UserProfileCTAItemViewModelProtocol]()
    var threePointsList:Array<UserProfileThreePointsItemViewModelProtocol> = [UserProfileThreePointsItemViewModelProtocol]()
    var isShowThreePoints: Bool = false

    typealias DataResultHandler = () -> ()

    typealias TableviewCellConfig = (UITableView, IndexPath) -> (UITableViewCell)
    var tableviewCellConfig: TableviewCellConfig?

    typealias ReloadSectionHandler = (Int) -> Void
    var reloadSectionHandler: ReloadSectionHandler?

    typealias ReloadCellHandler = (IndexPath) -> Void
    var reloadCellHandler: ReloadCellHandler?

    override init() {
        super.init()
    }
    
    //MARK: 数据请求 + 工厂类初始化sessionViewModel + 将数据源array通过闭包抛给vc中的tableview去做刷新 + 监听事件
    func requestData(result: DataResultHandler?)  {

        let reportItemModel = ProfileThreePointsInfo()
        reportItemModel.title = "举报"
        reportItemModel.type = "report"

        let suggestItemModel = ProfileThreePointsInfo()
        suggestItemModel.title = "建议"
        suggestItemModel.type = "suggest"

        let threePointsList: [ProfileThreePointsInfo] = [reportItemModel, suggestItemModel]
        self.threePointsList =  UserProfileViewModelFactory.createThreePointsViewModel(list: threePointsList)
        if self.threePointsList.count > 0 {
            isShowThreePoints = true
        }
        
        let jsonName = "UserProfileDict"

        guard let data = getDataFromFile(jsonName), let json = jsonSerial(data) as? [String: Any] else  {
            return
        }

        guard let model = UserProfileModel.deserialize(from: json) else {
            return
        }

        self.model = model
        self.array =  UserProfileViewModelFactory.createSessionViewModel(data: model)
        self.ctaList =  UserProfileViewModelFactory.createCTAViewModel(data: model)

        if let ctaInfo = model.ctaInfo, self.ctaList.count > 4 {
            let moreViewModel = UserProfileCTAMoreViewModel.init(ctaInfo: ctaInfo)
            let array = self.ctaList[3...]
            moreViewModel.array = Array(array)
            self.ctaList = Array(self.ctaList[...2])
            self.ctaList.append(moreViewModel)
        }

        if let result = result {
            result()
            observer()
        }
    }

    //MARK:有些事件需要依赖tableview，比如展开更多，所以需要监听list变化，然后将事件抛给 tableview 去做刷新
    func observer() {
        for sessionViewModel in self.array {
            guard let observableObject = sessionViewModel as? NSObject else {
                continue
            }
            //监听list的变化
            observableObject.addObserver(self, forKeyPath: "list", options: [.new], context:nil)

            guard let list = sessionViewModel.list else {
                continue
            }
            for cellViewModel in list {
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
            let sessionViewModel = object as? UserProfileDepartmentSessionViewModel
            if let sessionViewModel = sessionViewModel, let section = sessionViewModel.section {
                if let reloadSectionHandler = self.reloadSectionHandler {
                    reloadSectionHandler(section)
                }
            }
        } else if keyPath == "model.isShow" {
            let cellViewModel = object as? UserProfilePhoneCellViewModel
            if let cellViewModel = cellViewModel, let indexPath = cellViewModel.indexPath {
                if let reloadCellHandler = self.reloadCellHandler {
                    reloadCellHandler(indexPath)
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
            return config(tableView, indexPath)
        }
        return UITableViewCell()
    }
}
