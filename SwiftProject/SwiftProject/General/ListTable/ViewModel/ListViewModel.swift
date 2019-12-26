//
//  ListViewModel.swift
//  SwiftProject
//
//  Created by Ryan on 2019/12/20.
//  Copyright © 2019 cactus. All rights reserved.
//

import UIKit
import ObjectiveC
import SwiftyJSON
import HandyJSON

typealias successed = ([AnyHashable]?) -> Void
typealias failed = () -> ()

class ListViewModel: NSObject, UITableViewDataSource {

    private(set) var data: [ListModel]?
    private var failed: failed?
    private var successed: successed?

    private var url: String?
    private var tableviewCellConfig: ((_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell)?

    convenience init(array: [ListModel]) {
        self.init()
        data = array
    }

    required override init() {
        //先初始化自己的属性
        super.init()
        //再初始化继承来的属性
    }

    func configTableviewCell(_ cellConfig: @escaping (UITableView, IndexPath) -> UITableViewCell) {
        tableviewCellConfig = cellConfig

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.count ?? 0
    }

// MARK: - <UITableViewDataSource>
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableviewCellConfig != nil {
            return (tableviewCellConfig?(tableView, indexPath))!
        }
        return UITableViewCell()
    }

    func setDataLoadWithUrl(_ url: String?, successed aSuccessed: @escaping (_ dataSource: [AnyHashable]?) -> Void, failed: @escaping () -> ()) {
        self.url = url
        self.successed = aSuccessed
        self.failed = failed
        handleData()
    }

    func handleData() {

        let path = Bundle.main.path(forResource: url, ofType: "plist")
        let array = NSArray(contentsOfFile: path ?? "") as? [AnyHashable] ?? []

        var muArray: [AnyHashable] = []

        for dic in array {
            //let jsonData = JSON(dic)
            //let model = ListModel.init(jsonData: jsonData)
            let dict:[String : Any] = dic as! Dictionary
            if let model = ListModel.deserialize(from: dict) {
                muArray.append(model)
            }
        }


        data = muArray as! [ListModel];
        if data?.count ?? 0 <= 0 {
            if failed != nil {
                failed!();
            }
            return;
        }

        if successed != nil {
            successed!(data);
        }
    }
}
