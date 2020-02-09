//
//  BPViewModel.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2020/1/15.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class BPViewModel: NSObject, UITableViewDataSource {

    var array: [BPCellViewModelProtocol]?

    override init() {
        super.init()
        parseData()
    }

    private func parseData()  {
        guard let data = dataFromFile("b"), let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let body = json["data"] as? [String: Any] else  {
            return
        }

        guard let model = BPModel.deserialize(from: body) else {
            return
        }
        array = BPListFactory.createWithContent(data: model)!
    }

    private func dataFromFile(_ filename: String) -> Data? {
        @objc class TestClass: NSObject { }
        let bundle = Bundle(for: TestClass.self)
        if let path = bundle.path(forResource: filename, ofType: "geojson") {
            return (try? Data(contentsOf: URL(fileURLWithPath: path)))
        }
        return nil
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        guard let array1 = array else {
            return 0
        }
        return array1.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let array1 = array else {
            return 0
        }
        return array1.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let array1 = array else {
            return UITableViewCell()
        }
        let item:BPCellViewModelProtocol = array1[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: item.res, for: indexPath) as? BPTableCellProtocol

        cell?.setData(data: item)
        return cell as! UITableViewCell
    }
}
