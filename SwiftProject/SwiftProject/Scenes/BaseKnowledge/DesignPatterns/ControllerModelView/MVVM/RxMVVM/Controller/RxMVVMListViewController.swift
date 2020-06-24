//
//  RxMVVMListViewController.swift
//  SwiftProject
//
//  Created by Ryan on 2020/4/7.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RxMVVMListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    var cell1: RxMVVMTableViewCell? = nil

    fileprivate lazy var behaviorSubtitleCell: RxMVVMTableViewCell = {
        let nibName = String(describing: RxMVVMTableViewCell.self)
        let nib =  Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)
        return nib?.first as! RxMVVMTableViewCell
    }()
    
    @IBOutlet weak var tableView: UITableView!
    var second = 0
    var array = ["君不见黄河之水天上来，奔流到海不复回。君不见高堂明镜悲白发，朝如青丝暮成雪。人生得意须尽欢，莫使金樽空对月。天生我材必有用，千金散尽还复来"]
    var model: RxMVVMModelEnum {
        get {
            return .w
        }

        set {
            print(newValue)
        }
    }

    let dataObservable = BehaviorRelay<[String]>(value: ["君不见黄河之水天上来，奔流到海不复回。君不见高堂明镜悲白发，朝如青丝暮成雪。人生得意须尽欢，莫使金樽空对月。天生我材必有用，千金散尽还复来"])

    let disposeBag = DisposeBag()
    private static var isMenuShow = false

    override func viewDidLoad() {
        super.viewDidLoad()
        behaviorSubtitleCell.isHidden = true
        view.addSubview(behaviorSubtitleCell)
        tableView.estimatedRowHeight = 0
        self.model.update(RxMVVMModel())
        setupSubviews()
        let timer = Timer.init(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        timer.fire()
        RunLoop.current.add(timer, forMode: .default)


        NotificationCenter.default.addObserver(self, selector: #selector(willShowMenuNotification),
                                               name: NSNotification.Name(rawValue: "FloatMenuViewShow"),
                                               object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(didHideMenuNotification),
                                               name: NSNotification.Name(rawValue: "FloatMenuViewHidden"),
                                               object: nil)
        

    }

    @objc func willShowMenuNotification() {
        RxMVVMListViewController.isMenuShow = true
    }

    @objc func didHideMenuNotification() {
        RxMVVMListViewController.isMenuShow = false
        if dataObservable.value == array {
            return
        }
        dataObservable.accept(array)//对值进行修改。
    }

    @objc func timerAction() {
        second += 1
        array.append(String(second) + "君不见黄河之水天上来，奔流到海不复回。君不见高堂明镜悲白发，朝如青丝暮成雪。人生得意须尽欢，莫使金樽空对月。天生我材必有用，千金散尽还复来。")
        if !RxMVVMListViewController.isMenuShow {
            dataObservable.accept(array)//对值进行修改。
        }
    }

    func setupSubviews() {
        tableView.register(RxMVVMTableViewCell.nib, forCellReuseIdentifier: "Cell")
        tableView.estimatedRowHeight = 0
        tableView.dataSource = self
        tableView.rx.setDelegate(self)

        //1.创建可观察数据源
        //2. 将数据源与 tableView 绑定
        dataObservable
            .do(onNext: { (array) in
                self.tableView.reloadData()
                self.tableView.setNeedsLayout()
                self.tableView.layoutIfNeeded()
                self.tableView.scrollToBottom()
            }, afterNext: { array in
            }, onError: nil, afterError: nil, onCompleted: nil, afterCompleted: nil, onSubscribe: nil, onSubscribed: nil, onDispose: nil)
            .subscribe(onNext: { (texts) in
            }, onError: { (error) in

            }, onCompleted: {
            }, onDisposed: nil).disposed(by: disposeBag)

//        dataObservable.do(onNext: { (_) in
//        }, afterNext: { _ in
//            self.tableView.reloadData()
//            self.tableView.layoutIfNeeded()
//            DispatchQueue.main.async {
//                self.tableView.scrollToBottom()
//            }
//        }, onError: nil, afterError: nil, onCompleted: nil, afterCompleted: nil, onSubscribe: nil, onSubscribed: nil, onDispose: nil).bind(to: tableView.rx
//            .items(cellIdentifier: "Cell", cellType: RxMVVMTableViewCell.self)) { (row, text, cell) in
//                let attributeText = NSMutableAttributedString.init(string: text)
//                cell.attributedText = attributeText
//        }
//        .disposed(by: disposeBag)

        //3. 绑定 tableView 的事件
        //获取选中项的索引
//        tableView.rx.itemSelected.bind { (indexPath) in
//            //            print("选中项的indexPath为：\(indexPath)")
//        }
//        .disposed(by: disposeBag)
//
//        //获取选中项的内容
//        tableView.rx.modelSelected(String.self).bind{ item in
//            //            print("选中项的标题为：\(item)")
//        }.disposed(by: disposeBag)
//
//
//        Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(String.self))
//            .bind { [weak self] indexPath, item in
//                //            print("选中项的indexPath为：\(indexPath)")
//                //            print("选中项的标题为：\(item)")
//        }
//        .disposed(by: disposeBag)
//
//        //单元格将要显示出来的事件响应
//        tableView.rx.willDisplayCell.subscribe(onNext: { cell, indexPath in
//            //            print("将要显示单元格indexPath为：\(indexPath)")
//            //            print("将要显示单元格cell为：\(cell)\n")
//
//        }).disposed(by: disposeBag)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if var cell = tableView.dequeueReusableCell(withIdentifier: "Cell" , for: indexPath) as? RxMVVMTableViewCell {
            let attributeText = NSMutableAttributedString.init(string: array[indexPath.row])
            cell.attributedText = attributeText
            return cell as! UITableViewCell
        }else {
            return UITableViewCell()
        }
    }

    fileprivate lazy var sampleSubtitleCell: RxMVVMTableViewCell = {
        let nib = UINib(nibName: "RxMVVMTableViewCell", bundle: nil)
        return nib.instantiate(withOwner: nil, options: nil)[0] as! RxMVVMTableViewCell
    }()

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

//        // 使用
//        DispatchQueue.once {
//            // your code
//            cell1 = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RxMVVMTableViewCell
//        }

        let cell = behaviorSubtitleCell


//        guard let cell = cell1 else {
//            return 0
//        }
        cell.bounds.size.width =  UIScreen.main.bounds.size.width
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        cell.label.preferredMaxLayoutWidth = cell.label.width;

        let attributeText = NSMutableAttributedString.init(string: array[indexPath.row])
        cell.attributedText = attributeText
        let cellHeight = cell.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        let height =  (cellHeight)
        return height
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

    }
}

extension UIScrollView {

    var unifiedContentInset: UIEdgeInsets {
        return adjustedContentInset
    }

    var topEdgeContentOffset: CGPoint {
        return CGPoint(x: contentOffset.x, y: -unifiedContentInset.top)
    }

    var bottomEdgeContentOffset: CGPoint {
        let y = max(topEdgeContentOffset.y, contentSize.height - bounds.height + unifiedContentInset.bottom)
        return CGPoint(x: contentOffset.x, y: y)
    }

    func scrollToTop(animated: Bool = false) {
        setContentOffset(topEdgeContentOffset, animated: animated)
    }

    func scrollToBottom(animated: Bool = false) {
        setContentOffset(bottomEdgeContentOffset, animated: animated)
    }

}
extension DispatchQueue {
    private static var _onceToken = [String]()

    class func once(token: String = "\(#file):\(#function):\(#line)", block: ()->Void) {
        objc_sync_enter(self)

        defer
        {
            objc_sync_exit(self)
        }

        if _onceToken.contains(token)
        {
            return
        }

        _onceToken.append(token)
        block()
    }
}

