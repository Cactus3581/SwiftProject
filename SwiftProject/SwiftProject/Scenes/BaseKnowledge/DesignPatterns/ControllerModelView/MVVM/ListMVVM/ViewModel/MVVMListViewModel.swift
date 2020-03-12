//
//  MVVMListViewModel.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/11.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit



protocol MVVMListCellViewModelProtocol {
    
    // 生成 cellViewModel 的方法
    static func canHandle(type: String) -> Bool
    init(data: MVVMListModel)

    var identifier: String { get }
}

extension MVVMListCellViewModelProtocol {

    static func canHandle(type: String) -> Bool {
        return false
    }

    init(data: MVVMListModel) {
        self.init(data: data)
    }

    var cellHeight: Double {
       return 0
    }

    var identifier: String {
       return ""
    }
}

class MVVMListViewModel: NSObject {

    var array:Array<MVVMListCellViewModelProtocol> = [MVVMListCellViewModelProtocol]()

    override init() {
        super.init()
        handleData()
    }

    private func handleData()  {
        let dict = [
                "order":["button","image","label"],
                "button":[
                    "buttonTitle" : "ryan"
                ],

                "label":[
                    "labelTitle" : "cactus"
                ],

                "image":[
                    "imageUrl" : "navi_back"
                ]
            ] as [String : Any]

        guard let model = MVVMListModel.deserialize(from: dict) else {
            return
        }

        guard let data = MVVMListFactory.createWithContent(data: model)  else {
            return
        }

        array = data
    }
}

extension MVVMListViewModel: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item:MVVMListCellViewModelProtocol = array[indexPath.row]
        if var cell = tableView.dequeueReusableCell(withIdentifier: item.identifier, for: indexPath) as? MVVMListTableViewCellProtocol {
            cell.cellViewModel = item
            return cell as! UITableViewCell
        }else {
            return UITableViewCell()
        }


    }
}

class MVVMListLabelTableViewCellViewModel: MVVMListCellViewModelProtocol {

    var lableTitle: String?

    static func canHandle(type: String) -> Bool {
        if type == "label" {
            return true
        }
        return false
    }
    required init(data: MVVMListModel) {
        self.lableTitle = data.label?.labelTitle
    }

    var identifier: String {
       return "MVVMListLabelTableViewCell"
    }
}

class MVVMListImageTableViewCellViewModel: MVVMListCellViewModelProtocol {

    var imageUrl: String?

    static func canHandle(type: String) -> Bool {
        if type == "image" {
            return true
        }
        return false
    }

    required init(data: MVVMListModel) {
        self.imageUrl = data.image?.imageUrl
    }

    var identifier: String {
       return "MVVMListImageTableViewCell"
    }
}

class MVVMListButtonTableViewCellViewModel: MVVMListCellViewModelProtocol {

    var buttonTitle: String?

    static func canHandle(type: String) -> Bool {
        if type == "button" {
            return true
        }
        return false
    }

    required init(data: MVVMListModel) {
        self.buttonTitle = data.button?.buttonTitle
    }

    var identifier: String {
       return "MVVMListButtonTableViewCell"
    }

    func jump() {
        // 通过路由
    }

    func click() {
        // 具体事件具体分析
    }

    func updateData(result: ((MVVMListButtonTableViewCellViewModel) -> ())) {
        // 数据更新
        result(self)
    }
}
