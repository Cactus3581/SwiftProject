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
    weak var ctaAnimationView: UIView?

    static var isRemoving: Bool = false
    var naviHeight: CGFloat = 64

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

    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        let inset = self.view.safeAreaInsets
        var naviHeight = 44 as CGFloat;
        naviHeight = naviHeight + (inset.top  > 0 ? inset.top : 20)
        self.naviHeight = naviHeight
        naviBackView.snp.updateConstraints { (make) in
            make.height.equalTo(naviHeight)
        }
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

            let ctaViewHeight = self.headerView.ctaView?.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height ?? 0
            self.headerView.dependLayoutView1.snp.updateConstraints() {
                $0.height.equalTo(ctaViewHeight)
            }

            let headerViewHeight = self.headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            self.headerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: headerViewHeight)
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
        tableView.register(UserProfileDeparmentSectionFooterView.self, forHeaderFooterViewReuseIdentifier: UserProfileDeparmentSectionFooterView.identifier)
        tableView.register(UserProfileLineSectionFooterView.self, forHeaderFooterViewReuseIdentifier: UserProfileLineSectionFooterView.identifier)
        tableView.register(UserProfileTextTableViewCell.self, forCellReuseIdentifier: UserProfileTextTableViewCell.identifier)
        tableView.register(UserProfileLinkTableViewCell.self, forCellReuseIdentifier: UserProfileLinkTableViewCell.identifier)
        tableView.register(UserProfilePhoneTableViewCell.self, forCellReuseIdentifier: UserProfilePhoneTableViewCell.identifier)
        tableView.register(UserProfileDepartmentTableViewCell.self, forCellReuseIdentifier: UserProfileDepartmentTableViewCell.identifier)
        tableView.register(UserProfileMultiDepartmentTableViewCell.self, forCellReuseIdentifier: UserProfileMultiDepartmentTableViewCell.identifier)
        tableView.register(UserProfileAliasTableViewCell.self, forCellReuseIdentifier: UserProfileAliasTableViewCell.identifier)
        tableView.register(UserProfileUserStatusTableViewCell.self, forCellReuseIdentifier: UserProfileUserStatusTableViewCell.identifier)
    }

    func initializeViews() {

        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        self.tableView = tableView
        self.view.addSubview(tableView)

        let naviBackView = UIView()
        self.naviBackView = naviBackView
        self.view.addSubview(naviBackView)

        let backButton = UIButton()
        self.backButton = backButton
        self.view.addSubview(backButton)

        let titleLabel = UILabel()
        self.titleLabel = titleLabel
        naviBackView.addSubview(titleLabel)

        let threePointButton = UIButton()
        self.threePointButton = threePointButton
        self.view.addSubview(threePointButton)

        naviBackView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(self.naviHeight)
        }
        naviBackView.alpha = 0
        naviBackView.backgroundColor = UIColor.white;

        backButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(15)
            make.centerY.equalTo(titleLabel)
        }
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        backButton.setImage(UIImage(named: "player_back"), for: .normal)

        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-15)
            make.leading.greaterThanOrEqualTo(backButton.snp.trailing)
            make.trailing.lessThanOrEqualTo(threePointButton.snp.leading)
        }
        titleLabel.textAlignment = .center
        titleLabel.text = "mary"
        titleLabel.textColor = UIColor.darkText;

//        threePointButton.isHidden = true
        threePointButton.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-15)
            make.centerY.equalTo(backButton)
        }
        threePointButton.addTarget(self, action: #selector(showSheet), for: .touchUpInside)
        threePointButton.setImage(UIImage(named: "player_back"), for: .normal)

        tableView.contentInsetAdjustmentBehavior = .never
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        tableView.estimatedRowHeight = 50
        tableView.estimatedSectionHeaderHeight = 50
        tableView.estimatedSectionFooterHeight = 50

        let headerView = UserProfileTableHeaderView.init(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 0))
        self.headerView = headerView
        tableView.tableHeaderView = headerView

        tableView.delegate = self

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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sessionViewModel = viewModel.array[section]
        guard let _ = sessionViewModel.headerIdentifier else {
            return CGFloat.leastNormalMagnitude
        }
        return sessionViewModel.headerHeight ?? CGFloat.leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let sessionViewModel = viewModel.array[section]
        guard let _ = sessionViewModel.footerIdentifier else {
            return CGFloat.leastNormalMagnitude
        }
        return sessionViewModel.footerHeight ?? CGFloat.leastNormalMagnitude
    }

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
    func catViewAnimation(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        let imageHeight = (self.tableView.bounds.size.width / (375.0 / 330.0 ))

        let constantImageWidth = self.headerView.frame.size.width
        if (offsetY < 0) {
            let heightY = imageHeight + abs(offsetY) - 0;
            let f = heightY / imageHeight;
            self.headerView.coverImageView.snp.remakeConstraints{
                $0.top.equalToSuperview().offset(offsetY+0)
                $0.leading.equalTo( -(constantImageWidth * f - constantImageWidth) / 2)
                $0.width.equalTo(constantImageWidth * f)
                $0.height.equalTo(heightY)
            }
        }

        var catViewHeight = 0 as CGFloat
        if let ctaView = self.ctaView {
            catViewHeight = ctaView.bounds.size.height
        } else if let ctaView = self.headerView.ctaView {
            catViewHeight = ctaView.bounds.size.height
        }
        let gradualDistance = (self.headerView.bounds.size.height - self.naviBackView.bounds.size.height - catViewHeight - UserProfileTableHeaderView.bottom) as CGFloat
        if (offsetY <= gradualDistance) {
            let rate = offsetY / gradualDistance
            naviBackView?.alpha = rate;
            if (offsetY <= gradualDistance / 2.0) {
                // 由白到透明,proportion:1->0
                let proportion = 1 - min(1, (offsetY)/(gradualDistance / 2.0));
                backButton.setImage(UIImage(named: "player_back"), for: .normal)
                backButton.alpha = proportion;
            } else {
                // 由透明到黑
                let proportion = min(1, (offsetY - ((gradualDistance / 2.0)))/(gradualDistance / 2.0));
                backButton.setImage(UIImage(named: "icon_back"), for: .normal)
                backButton.alpha = proportion;
            }
        } else {
            naviBackView?.alpha = 1;
        }

        let time = 0.25
        if (offsetY <= gradualDistance) {
            if UserProfileViewController.isRemoving {
                return
            }
            if self.ctaView != nil {
                self.headerView.addSubview(self.ctaAnimationView!)
                self.headerView.addSubview(self.ctaView!)

                self.ctaAnimationView = nil
                self.ctaView = nil

                self.headerView.ctaAnimationView?.backgroundColor = UIColor.white
                self.headerView.ctaView?.backgroundColor = UIColor.white

                self.headerView.ctaAnimationView?.layer.cornerRadius = UserProfileCTAView.cornerRadius
                self.headerView.ctaView?.layer.cornerRadius = UserProfileCTAView.cornerRadius

                self.headerView.ctaAnimationView?.snp.remakeConstraints {
                    $0.leading.equalToSuperview().offset(0)
                    $0.trailing.equalToSuperview().offset(0)
                    $0.bottom.equalToSuperview().offset(-UserProfileTableHeaderView.bottom)
                    $0.height.equalTo(self.headerView.ctaView!.snp.height)
                }

                self.headerView.ctaView?.snp.remakeConstraints {
                    $0.leading.equalToSuperview().offset(16)
                    $0.trailing.equalToSuperview().offset(-16)
                    $0.bottom.equalToSuperview().offset(-UserProfileTableHeaderView.bottom)
                }
                self.headerView.ctaAnimationView?.setNeedsLayout()
                self.headerView.ctaAnimationView?.layoutIfNeeded()
                self.headerView.ctaView?.setNeedsLayout()
                self.headerView.ctaView?.layoutIfNeeded()

                self.headerView.ctaAnimationView?.snp.updateConstraints {
                    $0.leading.equalToSuperview().offset(16)
                    $0.trailing.equalToSuperview().offset(-16)
                }
                UserProfileViewController.isRemoving = true
                UIView.animate(withDuration: time, animations: {
                    self.headerView.ctaAnimationView?.setNeedsLayout()
                    self.headerView.ctaAnimationView?.layoutIfNeeded()
                }) { (success) in
                    if success {
                        UserProfileViewController.isRemoving = false
                    }
                }
            }
        } else {
            if offsetY > 0.0 {
                if ctaView == nil  {

                    self.ctaAnimationView = self.headerView.ctaAnimationView
                    self.view.addSubview(self.ctaAnimationView!)
                    self.ctaView = self.headerView.ctaView
                    self.view.addSubview(self.ctaView!)


                    self.ctaAnimationView!.backgroundColor = UIColor.white
                    self.ctaView!.backgroundColor = UIColor.white

                    self.ctaAnimationView?.snp.makeConstraints {
                         $0.leading.equalToSuperview().offset(16)
                         $0.trailing.equalToSuperview().offset(-16)
                         $0.top.equalTo(naviBackView!.snp.bottom)
                         $0.height.equalTo(self.ctaView!.snp.height)
                     }

                    self.ctaView?.snp.makeConstraints {
                        $0.leading.equalToSuperview().offset(16)
                        $0.trailing.equalToSuperview().offset(-16)
                        $0.top.equalTo(naviBackView!.snp.bottom)
                    }
                    self.ctaView?.setNeedsLayout()
                    self.ctaView?.layoutIfNeeded()
                    self.ctaAnimationView?.setNeedsLayout()
                    self.ctaAnimationView?.layoutIfNeeded()

                    self.ctaAnimationView?.snp.updateConstraints { (make) in
                        make.leading.equalToSuperview().offset(0)
                        make.trailing.equalToSuperview().offset(0)
                    }

                    UIView.animate(withDuration: time, animations: {
                        self.ctaAnimationView?.setNeedsLayout()
                        self.ctaAnimationView?.layoutIfNeeded()
                    }) { (success) in
                        if success {
                            self.ctaAnimationView?.layer.cornerRadius = 0
                        }
                    }
                }
            }
        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { (context) in
            self.tableView.reloadData()
        }) { (context) in

        }
    }
}
