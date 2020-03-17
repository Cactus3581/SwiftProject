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
        let dict = [
                "header" : "header",
                "footer" : "footer",
                "order":["button","sec"],
                "button":[
                    "buttonTitle" : "ryan"
                ],
                "sec":[
                    "list" : ["1","2","3","4","5","6","7","8"]
                ]
            ] as [String : Any]

        guard let model = MVVMListSecModel.deserialize(from: dict) else {
            return
        }
        self.model = model
        guard let data = MVVMListSecFactory.createWithContent(data: model)  else {
            return
        }

        array = data
    }

    func click(){
        print("tableHeader/FooterView click")
    }

    func jump(){
        print("tableHeader/FooterView jump")
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
        if var cell = tableView.dequeueReusableCell(withIdentifier: item?.identifier ?? "", for: indexPath) as? MVVMListSecTableViewCellProtocol {
            cell.cellViewModel = item!
            return cell as! UITableViewCell
        }else {
            return UITableViewCell()
        }
    }
}
