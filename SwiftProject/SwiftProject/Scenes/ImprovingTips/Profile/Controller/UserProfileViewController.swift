//
//  UserProfileViewController.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/11.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class UserProfileViewController: BaseViewController, UITableViewDelegate {
    

    weak var naviBackView: UIView!
    weak var titleLabel: UILabel!
    weak var backButton: UIButton!
    weak var threePointButton: UIButton!
    weak var tableView: UITableView!
    weak var headerView: UserProfileTableHeaderView!
    weak var ctaView: UserProfileCTAView?

    static var isRemoving: Bool = false

    fileprivate var viewModel: UserProfileViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableViewSessionViewModel()
        initializeViews()
        initializeViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    // 注册 sessionViewModel
    func registerTableViewSessionViewModel() {
        UserProfileAssembly.register()
    }

    // 创建 ViewModel
    func initializeViewModel() {
        self.viewModel = UserProfileViewModel()
        tableView.dataSource = viewModel
        viewModel.configTableviewCell(config: { [weak self] (tableView, indexPath) -> (UITableViewCell) in
            guard let `self` = self else {
                return UITableViewCell()
            }
            let sectionViewModel: UserProfileSessionViewModelProtocol = self.viewModel.array[indexPath.section]
            let cellViewModel = sectionViewModel.list?[indexPath.row]
            if var cell = tableView.dequeueReusableCell(withIdentifier: sectionViewModel.identifier , for: indexPath as IndexPath) as? UserProfileTableViewCellProtocol {
                cell.cellViewModel = cellViewModel!
                cell.indexPath = indexPath
                return cell as! UITableViewCell
            }else {
                return UITableViewCell()
            }
        })

        viewModel.requestData(result: {[weak self] () -> Void in
            guard let `self` = self else {
                return
            }
            self.headerView.viewModel = self.viewModel
            self.tableView.reloadData()
        })

        //MARK:事件
        self.viewModel.reloadCellHandler = { indexPath in
            self.tableView.reloadRows(at: [(indexPath as IndexPath)], with: .fade)
        }

        self.viewModel.reloadSectionHandler = { section in
            self.tableView.reloadSections([section], with: .fade)
        }
    }

    // 向tableView注册views
    func registerViews() {
        tableView.register(UserProfileSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: UserProfileSectionHeaderView.identifier)
        tableView.register(UserProfileSectionFooterView.self, forHeaderFooterViewReuseIdentifier: UserProfileSectionFooterView.identifier)
        tableView.register(UserProfileTextTableViewCell.self, forCellReuseIdentifier: UserProfileTextTableViewCell.identifier)
        tableView.register(UserProfileLinkTableViewCell.self, forCellReuseIdentifier: UserProfileLinkTableViewCell.identifier)
        tableView.register(UserProfilePhoneTableViewCell.self, forCellReuseIdentifier: UserProfilePhoneTableViewCell.identifier)
        tableView.register(UserProfileMultiDepartmentTableViewCell.self, forCellReuseIdentifier: UserProfileMultiDepartmentTableViewCell.identifier)
        tableView.register(UserProfileAliasTableViewCell.self, forCellReuseIdentifier: UserProfileAliasTableViewCell.identifier)
        tableView.register(UserProfileUserStatusTableViewCell.self, forCellReuseIdentifier: UserProfileUserStatusTableViewCell.identifier)
    }

    func initializeViews() {
        
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        self.tableView = tableView
        tableView.contentInsetAdjustmentBehavior = .never
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        tableView.estimatedRowHeight = 50
        tableView.estimatedSectionHeaderHeight = 50
        tableView.estimatedSectionFooterHeight = 50

        let headerView =  UserProfileTableHeaderView.init(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: UserProfileTableHeaderView.height))
        self.headerView = headerView
        tableView.tableHeaderView = headerView

        tableView.delegate = self
        
        let naviBackView = UIView()
        self.naviBackView = naviBackView
        view.addSubview(naviBackView)
        naviBackView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(88)
        }
        naviBackView.alpha = 0
        naviBackView.backgroundColor = UIColor.white;

        
        let titleLabel = UILabel()
        self.titleLabel = titleLabel
        naviBackView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-15)
        }
        titleLabel.text = "mary"
        titleLabel.textColor = UIColor.darkText;

        let backButton = UIButton()
        self.backButton = backButton
        self.view!.addSubview(backButton)
        backButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(15)
            make.bottom.equalTo(titleLabel)
        }
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        backButton.setImage(UIImage(named: "player_back"), for: .normal)

//        if self.viewModel.isShowThreePoints {
            let threePointButton = UIButton()
            self.threePointButton = threePointButton
            self.view!.addSubview(threePointButton)
            threePointButton.snp.makeConstraints { (make) in
                make.trailing.equalToSuperview().offset(-15)
                make.bottom.equalTo(titleLabel)
            }
            threePointButton.addTarget(self, action: #selector(showSheet), for: .touchUpInside)
            threePointButton.setImage(UIImage(named: "player_back"), for: .normal)
//        }
        registerViews()
    }
    
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc func showSheet() {
        let alert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        for viewModel in self.viewModel.threePointsList {
            let action = UIAlertAction(title: viewModel.title, style: .default, handler: {
                action in
                viewModel.didClickSheet()
            })
            alert.addAction(action)
        }

        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }

    //MARK:UITableViewDelagate
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sessionViewModel = viewModel.array[section]
        guard let identifier = sessionViewModel.headerIdentifier else {
            return nil
        }
        guard var view = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier) as? UserProfileSectionViewProtocol else {
            return nil
        }
        view.sessionViewModel = viewModel.array[section]
        view.section = section
        return view as? UIView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let sessionViewModel = viewModel.array[section]
        guard let identifier = sessionViewModel.footerIdentifier else {
            return nil
        }

        guard var view = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier) as? UserProfileSectionViewProtocol else {
            return nil
        }
        view.sessionViewModel = viewModel.array[section]
        view.section = section
        return view as? UIView
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        let sessionViewModel = viewModel.array[section]
//        return sessionViewModel.viewHeight ?? 0
//    }
//
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        let sessionViewModel = viewModel.array[section]
//        return sessionViewModel.viewHeight ?? 0
//    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = self.viewModel else {
            return
        }

        let sectionViewModel: UserProfileSessionViewModelProtocol = viewModel.array[indexPath.section]
        let cellViewModel = sectionViewModel.list?[indexPath.row]
        if let cellViewModel = cellViewModel {
            sectionViewModel.didSelectCellViewModel(cellViewModel: cellViewModel, indexPath: indexPath as IndexPath)
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        catViewAnimation(scrollView)
    }
    
    //MARK:导航栏动画
    func catViewAnimation1(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        let time = 0.25

        var catViewHeight = 0 as CGFloat

        if let ctaView = self.ctaView {
            catViewHeight = ctaView.bounds.size.height
        } else {
            catViewHeight = self.headerView.ctaView.bounds.size.height
        }

        let imageHeight = UserProfileTableHeaderView.height - catViewHeight/2 - UserProfileTableHeaderView.bottom
        let width = self.tableView.frame.size.width;

        if (offsetY < 0) {
            let heightY = imageHeight + abs(offsetY) - 0;
            let f = heightY / imageHeight;
            self.headerView.coverImageView.snp.remakeConstraints{
                $0.top.equalToSuperview().offset(offsetY+0)
                $0.leading.equalTo( -(width * f - width) / 2)
                $0.width.equalTo(width * f)
                $0.height.equalTo(heightY)
            }
        }

        let height = (UserProfileTableHeaderView.height - self.naviBackView.bounds.size.height - catViewHeight - UserProfileTableHeaderView.bottom) as CGFloat
        if (offsetY <= height) {
            let rate = offsetY / height
            naviBackView?.alpha = rate;
            if (offsetY <= height / 2.0) {
                // 由白到透明,proportion:1->0
                let proportion = 1 - min(1, (offsetY)/(height / 2.0));
                backButton.setImage(UIImage(named: "player_back"), for: .normal)
                backButton.alpha = proportion;
            } else {
                // 由透明到黑
                let proportion = min(1, (offsetY - ((height / 2.0)))/(height / 2.0));
                backButton.setImage(UIImage(named: "icon_back"), for: .normal)
                backButton.alpha = proportion;
            }
        } else {
            naviBackView?.alpha = 1;
        }
        
        if (offsetY <= height) {
            if UserProfileViewController.isRemoving {
                return
            }
            if self.ctaView != nil {
                self.headerView.addSubview(self.ctaView!)
                self.ctaView = nil
                self.headerView.ctaView.contentView.layer.cornerRadius = UserProfileCTAView.cornerRadius
                self.headerView.ctaView.snp.remakeConstraints {
                    $0.leading.equalToSuperview().offset(0)
                    $0.trailing.equalToSuperview().offset(0)
                    $0.bottom.equalToSuperview().offset(-UserProfileTableHeaderView.bottom)
                }
                self.headerView.ctaView.setNeedsLayout()
                self.headerView.ctaView.layoutIfNeeded()
                self.headerView.ctaView.snp.updateConstraints {
                    $0.leading.equalToSuperview().offset(16)
                    $0.trailing.equalToSuperview().offset(-16)
                }
                UserProfileViewController.isRemoving = true
                UIView.animate(withDuration: time, animations: {
                    self.headerView.ctaView.setNeedsLayout()
                    self.headerView.ctaView.layoutIfNeeded()
                }) { (success) in
                    if success {
                        UserProfileViewController.isRemoving = false
                    }
                }
            }
        } else {
            if offsetY > 0.0 {
                if ctaView == nil  {
                    self.ctaView = self.headerView.ctaView
                    self.view.addSubview(self.ctaView!)
                    self.ctaView?.snp.makeConstraints {
                        $0.leading.equalToSuperview().offset(UserProfileTableHeaderView.bottom)
                        $0.trailing.equalToSuperview().offset(-UserProfileTableHeaderView.bottom)
                        $0.top.equalTo(naviBackView!.snp.bottom)
                    }
                    self.ctaView?.setNeedsLayout()
                    self.ctaView?.layoutIfNeeded()
                    self.ctaView?.snp.updateConstraints { (make) in
                        make.leading.equalToSuperview().offset(0)
                        make.trailing.equalToSuperview().offset(0)
                    }
                    
                    UIView.animate(withDuration: time, animations: {
                        self.ctaView?.setNeedsLayout()
                        self.ctaView?.layoutIfNeeded()
                    }) { (success) in
                        if success {
                            self.ctaView?.contentView.layer.cornerRadius = 0
                        }
                    }
                }
            }
        }
    }
    
    //MARK:导航栏动画
    func catViewAnimation(_ scrollView: UIScrollView) {

        let offsetY = scrollView.contentOffset.y
        let time = 0.25

        let imageHeight = UserProfileTableHeaderView.height - UserProfileCTAView.height/2.0 - UserProfileTableHeaderView.bottom
        let width = self.tableView.frame.size.width;

        if (offsetY < 0) {
            let heightY = imageHeight + abs(offsetY) - 0;
            let f = heightY / imageHeight;
            self.headerView.coverImageView.snp.remakeConstraints{
                $0.top.equalToSuperview().offset(offsetY+0)
                $0.leading.equalTo( -(width * f - width) / 2)
                $0.width.equalTo(width * f)
                $0.height.equalTo(heightY)
            }
        }

        let height = (UserProfileTableHeaderView.height - UserProfileCTAView.height-UserProfileTableHeaderView.bottom - self.naviBackView.bounds.size.height) as CGFloat
        if (offsetY <= height) {
            let rate = offsetY / height
            naviBackView?.alpha = rate;
            if (offsetY <= height / 2.0) {
                // 由白到透明,proportion:1->0
                let proportion = 1 - min(1, (offsetY)/(height / 2.0));
                backButton.setImage(UIImage(named: "player_back"), for: .normal)
                backButton.alpha = proportion;
            } else {
                // 由透明到黑
                let proportion = min(1, (offsetY - ((height / 2.0)))/(height / 2.0));
                backButton.setImage(UIImage(named: "icon_back"), for: .normal)
                backButton.alpha = proportion;
            }
        } else {
            naviBackView?.alpha = 1;
        }

        if (offsetY <= height) {
            if UserProfileViewController.isRemoving {
                return
            }
            if self.ctaView != nil {
                self.headerView.addSubview(self.ctaView!)
                self.ctaView = nil
                self.headerView.ctaView.layer.cornerRadius = UserProfileCTAView.cornerRadius
                self.headerView.ctaView.snp.remakeConstraints {
                    $0.leading.equalToSuperview().offset(0)
                    $0.trailing.equalToSuperview().offset(0)
                    $0.height.equalTo(UserProfileCTAView.height)
                    $0.bottom.equalToSuperview().offset(-UserProfileTableHeaderView.bottom)
                }
                self.headerView.ctaView.setNeedsLayout()
                self.headerView.ctaView.layoutIfNeeded()
                self.headerView.ctaView.snp.updateConstraints {
                    $0.leading.equalToSuperview().offset(UserProfileTableHeaderView.bottom)
                    $0.trailing.equalToSuperview().offset(-UserProfileTableHeaderView.bottom)
                }
                UserProfileViewController.isRemoving = true
                UIView.animate(withDuration: time, animations: {
                    self.headerView.ctaView.setNeedsLayout()
                    self.headerView.ctaView.layoutIfNeeded()
                }) { (success) in
                    if success {
                        UserProfileViewController.isRemoving = false
                    }
                }
            }
        } else {
            if offsetY > 0.0 {
                if ctaView == nil  {
                    self.ctaView = self.headerView.ctaView
                    self.view.addSubview(self.ctaView!)
                    self.ctaView?.snp.makeConstraints {
                        $0.leading.equalToSuperview().offset(UserProfileTableHeaderView.bottom)
                        $0.trailing.equalToSuperview().offset(-UserProfileTableHeaderView.bottom)
                        $0.height.equalTo(UserProfileCTAView.height)
                        $0.top.equalTo(naviBackView!.snp_bottom)
                    }
                    self.ctaView?.setNeedsLayout()
                    self.ctaView?.layoutIfNeeded()
                    self.ctaView?.snp.updateConstraints { (make) in
                        make.leading.equalToSuperview().offset(0)
                        make.trailing.equalToSuperview().offset(0)
                    }

                    UIView.animate(withDuration: time, animations: {
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
}
