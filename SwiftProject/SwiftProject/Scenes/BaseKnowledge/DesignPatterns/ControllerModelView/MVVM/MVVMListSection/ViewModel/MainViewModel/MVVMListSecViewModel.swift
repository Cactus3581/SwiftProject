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
                "header" : "页眉",
                "footer" : "页脚",
                "order":["listening","listeningSame","circle","speak","course","group"],
                "listening":[
                    "ListeningName" : "VOA"
                ],
                "listeningSame":[
                    "ListeningName" : "VOE"
                ],
                "circle":[
                    "ListeningName" : "VOD"
                ],
                "speak":[
                    "list" : [
                              ["speakScore": "100"],
                              ["speakScore": "98"]
                            ]
                ],
                "course":[
                    "list" : [
                              ["courseName": "英语四级","courseTeacher": "tom1"],
                              ["courseName": "英语六级","courseTeacher": "tom2"],
                              ["courseName": "英语八级","courseTeacher": "tom3"],
                              ["courseName":"雅思","courseTeacher":"tom4"],
                              ["courseName": "托福","courseTeacher": "tom5"]
                            ]
                ],
                "group":[
                
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
        if var cell = tableView.dequeueReusableCell(withIdentifier: section.identifier ?? "", for: indexPath) as? MVVMListSecTableViewCellProtocol {
            cell.cellViewModel = item!
            return cell as! UITableViewCell
        }else {
            return UITableViewCell()
        }
    }

}
