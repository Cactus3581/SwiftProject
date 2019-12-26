//
//  ListViewController.swift
//  SwiftProject
//
//  Created by Ryan on 2019/12/19.
//  Copyright © 2019 cactus. All rights reserved.
//

import UIKit
import SnapKit

class ListViewController: BaseViewController, UITableViewDelegate {

    var url: String?/* 作为主导航用的 */

    private var _dataArray: [AnyHashable]?// 其他业务页面
    private var dataArray: [AnyHashable]? {
        set {
            _dataArray = newValue
        }
        get {
            if _dataArray == nil {
                _dataArray = []
            }
            return _dataArray
        }
    }

    private var _viewModel: ListViewModel?
    private var viewModel: ListViewModel? {
        if _viewModel == nil {
            var viewModel: ListViewModel?
            if dataArray!.count > 0 {
                viewModel = ListViewModel(array: dataArray as! [ListModel])
            } else if (url != nil) {
                viewModel = ListViewModel()
                viewModel?.setDataLoadWithUrl(url, successed: { dataSource in
                    self.dataArray = dataSource
                    self.tableView?.reloadData()
                }, failed: {
                })
            }

            viewModel?.configTableviewCell({ tableView, indexPath in
                let cell = ListTableViewCell.cellWithTableView(tableView,indexPath:indexPath)
                cell.setModel((viewModel?.data?[indexPath.row])!, indexPath: indexPath as NSIndexPath)
                return cell
            })
            _viewModel = viewModel
        }
        return _viewModel
    }

    private var tableView: UITableView?

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
    }

    func initializeUI() {
        tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView?.delegate = self
        view.addSubview(tableView!)
        tableView?.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        tableView?.backgroundColor = UIColor.white
        tableView?.separatorStyle = .singleLine
        tableView?.tableHeaderView = UIView()
        tableView?.tableFooterView = UIView()
        //warning: 注意不能是CGFLOAT_MIN
        tableView?.estimatedRowHeight = 0
        tableView?.estimatedSectionHeaderHeight = 0
        tableView?.estimatedSectionFooterHeight = 0
        tableView?.dataSource = viewModel
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataArray?[indexPath.row] as? ListModel
        let className = model?.fileName ?? ""

        //1:动态获取命名空间
        guard let nameSpace = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else {
            print("获取命名空间失败")
            return
        }

        let vcClass: AnyClass? = NSClassFromString(nameSpace + "." + className) //VCName:表示试图控制器的类名
         // Swift中如果想通过一个Class来创建一个对象, 必须告诉系统这个Class的确切类型
        guard let classVc = vcClass as? UIViewController.Type else {
             print("vcClass不能当做UIViewController")
             return
         }

        if model?.subVc_array?.count != nil {
            let vc: ListViewController? = classVc.init() as? ListViewController
            vc?.title = model?.title
            //[vc setLeftBarButtonTitle:LocalizedString(_naviItem_backTitle)];
            vc?.dataArray = model?.subVc_array
            vc?.hidesBottomBarWhenPushed = true
            if let vc = vc {
                navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            let vc: BaseViewController? = BaseViewController.init()
            vc?.hidesBottomBarWhenPushed = true
            //vc.navigationItem.title = model.title;
            vc?.title = model?.title
            let dict = ["type": NSNumber(value: indexPath.row)]
            model?.dynamicJumpString = toJSONString(dict: dict as NSDictionary);// 暂时不用plist的元数据了，因为个人开发用，有些麻烦，如果正式用，必须用plist的数据
            vc?.dynamicJumpString = model?.dynamicJumpString;

            if let vc = vc {
                navigationController?.pushViewController(vc, animated: true)
            }
        }
        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = false
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {

    }

    func toJSONString(dict: NSDictionary?) -> String {
        let data = try? JSONSerialization.data(withJSONObject: dict!, options: JSONSerialization.WritingOptions.prettyPrinted)
        let strJson = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
        return strJson! as String
    }
}
