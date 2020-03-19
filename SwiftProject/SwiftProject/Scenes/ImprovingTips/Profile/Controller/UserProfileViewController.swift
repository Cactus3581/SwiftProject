//
//  UserProfileViewController.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/11.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit


class UserProfileViewController: BaseViewController, UITableViewDelegate {

    fileprivate var viewModel: UserProfileViewModel?
    var naviBackView: UIView?
    var titleLabel: UILabel?
    var backButton: UIButton?

    var tableView: UITableView?
    var headerView: UserProfileTableHeaderView?
    var ctaView: UserProfileCTAView?
    static var isRemoving: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // 注册 sessionViewModel
        UserProfileAssembly.register()
        // 创建 ViewModel
        self.viewModel = UserProfileViewModel()
        // 创建 tableView
        initializeViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    func initializeViews() {

        self.tableView = UITableView(frame: CGRect.zero, style: .grouped)
        self.tableView?.contentInsetAdjustmentBehavior = .never
        view.addSubview(tableView!)

        tableView?.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        tableView?.backgroundColor = UIColor.white
        tableView?.separatorStyle = .singleLine

        tableView?.register(UserProfileSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: UserProfileSectionHeaderView.identifier)
        tableView?.register(UserProfileCourseTableViewCell.self, forCellReuseIdentifier: UserProfileCourseTableViewCell.identifier)
        tableView?.register(UserProfileListeningTableViewCell.self, forCellReuseIdentifier: UserProfileListeningTableViewCell.identifier)

        let headerView =  UserProfileTableHeaderView.init(frame: CGRect(x: 0, y: 0, width: tableView?.bounds.width ?? 0, height: 300))
        self.headerView = headerView
        tableView?.tableHeaderView = headerView
        headerView.viewModel = viewModel
        let footerView =  UserProfileTableFooterView.init(frame: CGRect(x: 0, y: 0, width: tableView?.bounds.width ?? 0, height: 50))
        tableView?.tableFooterView = footerView
        footerView.viewModel = viewModel

        tableView?.estimatedRowHeight = 50
        tableView?.estimatedSectionHeaderHeight = 50
        tableView?.estimatedSectionFooterHeight = 50

        tableView?.dataSource = viewModel
        tableView?.delegate = self

        self.naviBackView = UIView()
        self.naviBackView?.backgroundColor = UIColor.white;
        naviBackView?.alpha = 0
        view.addSubview(self.naviBackView!)
        self.naviBackView?.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(88)
        }

         self.titleLabel = UILabel()
         titleLabel?.text = "mary"
//         titleLabel?.alpha = 0;
         titleLabel?.textColor = UIColor.darkText;
         naviBackView!.addSubview(titleLabel!)
         titleLabel?.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-15)
//            make.centerX.equalTo(naviBackView!)
//            make.bottom.equalTo(naviBackView!.snp_bottom).offset(-15)
         }
        self.backButton = UIButton()
        self.backButton?.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        backButton?.setImage(UIImage(named: "player_back"), for: .normal)
        self.view!.addSubview(backButton!)
        backButton?.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(15)
            make.bottom.equalTo(titleLabel!)
        }
    }

    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let viewModel = viewModel else {
            return nil
        }

        let sessionViewModel = viewModel.array[section]
        if var view = tableView.dequeueReusableHeaderFooterView(withIdentifier: sessionViewModel.headerIdentifier) as? UserProfileSectionViewProtocol {
            view.sessionViewModel = viewModel.array[section]
            return view as? UIView
        }
        return nil
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        catViewAnimation(scrollView)
    }

    //MARK:导航栏动画
    func catViewAnimation(_ scrollView: UIScrollView) {

        let offsetY = scrollView.contentOffset.y
        let height = (self.headerView!.bounds.size.height-self.headerView!.ctaView!.bounds.size.height-(15 as CGFloat) - self.naviBackView!.bounds.size.height)as CGFloat

        if (offsetY <= height) {
            let rate = offsetY / height
            naviBackView?.alpha = rate;
            if (offsetY <= height / 2.0) {
                // 由白到透明,proportion:1->0
                let proportion = 1 - min(1, (offsetY)/(height / 2.0));
                backButton?.setImage(UIImage(named: "player_back"), for: .normal)
                backButton?.alpha = proportion;
            } else {
                // 由透明到黑
                let proportion = min(1, (offsetY - ((height / 2.0)))/(height / 2.0));
                backButton?.setImage(UIImage(named: "icon_back"), for: .normal)
                backButton?.alpha = proportion;
            }
        } else {
            naviBackView?.alpha = 1;
        }

            if (offsetY <= height) {
                if UserProfileViewController.isRemoving {
                    return
                }
                if self.ctaView != nil {
                    self.headerView?.addSubview(self.ctaView!)
                    self.ctaView = nil
                    self.headerView?.ctaView?.layer.cornerRadius = 8
                    self.headerView?.ctaView?.snp.remakeConstraints {
                        $0.leading.equalToSuperview().offset(0)
                        $0.trailing.equalToSuperview().offset(0)
                        $0.height.equalTo(60)
                        $0.bottom.equalToSuperview().offset(-15)
                    }
                    self.headerView?.ctaView?.setNeedsLayout()
                    self.headerView?.ctaView?.layoutIfNeeded()
                    self.headerView?.ctaView?.snp.updateConstraints {
                        $0.leading.equalToSuperview().offset(15)
                        $0.trailing.equalToSuperview().offset(-15)
                    }
                    UserProfileViewController.isRemoving = true
                    UIView.animate(withDuration: 0.25, animations: {
                        self.headerView?.ctaView?.setNeedsLayout()
                        self.headerView?.ctaView?.layoutIfNeeded()
                    }) { (success) in
                        if success {
                            UserProfileViewController.isRemoving = false
                        }
                    }
                }
            } else {
                if offsetY > 0.0 {
                    if ctaView == nil  {
                        self.ctaView = self.headerView?.ctaView
                        self.view.addSubview(self.ctaView!)
                        self.ctaView?.snp.makeConstraints {
                            $0.leading.equalToSuperview().offset(15)
                            $0.trailing.equalToSuperview().offset(-15)
                            $0.height.equalTo(60)
                            $0.top.equalTo(naviBackView!.snp_bottom)
                        }
                        self.ctaView?.setNeedsLayout()
                        self.ctaView?.layoutIfNeeded()
                        self.ctaView?.snp.updateConstraints { (make) in
                            make.leading.equalToSuperview().offset(0)
                            make.trailing.equalToSuperview().offset(0)
                        }

                        UIView.animate(withDuration: 0.25, animations: {
                               self.ctaView?.setNeedsLayout()
                                self.ctaView?.layoutIfNeeded()
                        }) { (success) in
                            if success {
                                self.ctaView?.layer.cornerRadius = 0
                            }
                        }
                    }
                }
            }
        }

//        if (offsetY <= height && !UserProfileViewController.isRemoving) {
//            if ctaView != nil {
//                self.ctaView?.layer.cornerRadius = 8
//                self.ctaView?.snp.remakeConstraints {
//                    $0.leading.equalToSuperview().offset(0)
//                    $0.trailing.equalToSuperview().offset(0)
//                    $0.height.equalTo(60)
//                    $0.bottom.equalTo(self.headerView!.ctaView!.snp_bottom)
//                }
//                self.ctaView?.setNeedsLayout()
//                self.ctaView?.layoutIfNeeded()
//                self.ctaView?.snp.updateConstraints {
//                    $0.leading.equalToSuperview().offset(15)
//                    $0.trailing.equalToSuperview().offset(-15)
//                }
//                UserProfileViewController.isRemoving = true
//                UIView.animate(withDuration: 0.25, animations: {
//                    self.ctaView?.setNeedsLayout()
//                    self.ctaView?.layoutIfNeeded()
//                }) { (success) in
//                    if success {
//                        self.ctaView?.removeFromSuperview()
//                        self.ctaView = nil
//                        UserProfileViewController.isRemoving = false
//                    }
//                }
//            }
//        } else {
//            if offsetY > 0.0 {
//                if ctaView == nil  {
//                    self.ctaView = UserProfileCTAView()
//                    self.ctaView?.layer.cornerRadius = 8
//                    self.view.addSubview(self.ctaView!)
//                    self.ctaView?.snp.makeConstraints {
//                        $0.leading.equalToSuperview().offset(15)
//                        $0.trailing.equalToSuperview().offset(-15)
//                        $0.height.equalTo(60)
//                        $0.top.equalTo(naviBackView!.snp_bottom)
//                    }
//                    self.ctaView?.setNeedsLayout()
//                    self.ctaView?.layoutIfNeeded()
//                    self.ctaView?.snp.updateConstraints { (make) in
//                        make.leading.equalToSuperview().offset(0)
//                        make.trailing.equalToSuperview().offset(0)
//                    }
//
//                    UIView.animate(withDuration: 0.25) {
//                        self.ctaView?.setNeedsLayout()
//                        self.ctaView?.layoutIfNeeded()
//                    }
//
//                    UIView.animate(withDuration: 0.25, animations: {
//                           self.ctaView?.setNeedsLayout()
//                            self.ctaView?.layoutIfNeeded()
//                    }) { (success) in
//                        if success {
//                            self.ctaView?.layer.cornerRadius = 0
//                        }
//                    }
//                }
//            }
//        }
//    }
}
