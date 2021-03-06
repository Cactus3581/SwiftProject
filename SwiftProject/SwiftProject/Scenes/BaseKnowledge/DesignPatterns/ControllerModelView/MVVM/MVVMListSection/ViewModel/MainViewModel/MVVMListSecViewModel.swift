//
//  MVVMListSecViewModel.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/11.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class MVVMListSecViewModel: NSObject {

    var array:Array<MVVMListSectionViewModelProtocol> = [MVVMListSectionViewModelProtocol]()

    var model: MVVMListSecModel?

    override init() {
        super.init()
        handleData()
    }

    private func handleData()  {

        let jsonName = "MVVMListSectionArray"
        //let jsonName = "MVVMListSectionDict"

        guard let data = getDataFromFile(jsonName), let json = jsonSerial(data) as? [String: Any] else  {
            return
        }

        guard let model = MVVMListSecModel.deserialize(from: json) else {
            return
        }

        self.model = model
        if jsonName ==  "MVVMListSectionArray" {
            if let data1 = MVVMListSecFactory.createSessionViewModelByArray(data: model) {
                array = data1
            }
        } else if jsonName == "MVVMListSectionDict" {
            if let data1 = MVVMListSecFactory.createSessionViewModelByDict(data: model) {
                array = data1
            }
        }
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

extension MVVMListSecViewModel: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return array.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section:MVVMListSectionViewModelProtocol = array[section]
        return section.list?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section:MVVMListSectionViewModelProtocol = array[indexPath.section]
        let item = section.list?[indexPath.row]
        if var cell = tableView.dequeueReusableCell(withIdentifier: section.identifier , for: indexPath) as? MVVMListSecTableViewCellProtocol {
            cell.cellViewModel = item!
            return cell as! UITableViewCell
        }else {
            return UITableViewCell()
        }
    }

}
