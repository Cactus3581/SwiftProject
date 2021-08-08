//
//  ContainViewController.swift
//  UDCCatalog
//
//  Created by Ryan on 2021/7/5.
//  Copyright © 2021 Ryan. All rights reserved.
//

import Foundation
import SnapKit

enum ScrollDirection: Int {
    case unknown = 0,
         up,  // 向上滑动
         down  // 向下滑动
}

enum HeaderVisibleStatus: Int {
    case invisible = 0, // 不可见
         partVisible,  // 展示部分
         fullVisible  // 展示完整
}

enum ScrollState {
    case scrollViewCanScroll
    case tableViewCanScroll
}

class ContainViewController: BaseViewController {

    let scrollView = FeedScrollView()
    let headerView = HeaderView()
    let flowCatagoryView = FlowCatagoryView()
    let listContainerView = ListContainerView()

    let dataSource = ["A", "B"]
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        layout()
        observeOffsetChange()
    }
}

// MARK: 创建及基本布局
extension ContainViewController {
    
    func setupViews() {
        self.view.backgroundColor = UIColor.white

        scrollView.backgroundColor = .gray
        scrollView.delegate = self
        scrollView.clipsToBounds = true
        scrollView.bounces = true
        scrollView.alwaysBounceVertical = true
        scrollView.alwaysBounceHorizontal = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        
        headerView.delegate = self
    
        flowCatagoryView.titles = dataSource
        flowCatagoryView.collectionView.delegate = self
        
        listContainerView.parentViewController = self
        listContainerView.change(key: dataSource.first!)
    }

    // 布局
    func layout() {
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
            make.leading.trailing.bottom.width.equalToSuperview()
        }

        scrollView.addSubview(headerView)
        headerView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(headerView.headerViewHeight)
        }
        
        scrollView.addSubview(flowCatagoryView)
        flowCatagoryView.snp.makeConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(flowCatagoryView.flowCatagoryViewHeight)
        }
        
        scrollView.addSubview(listContainerView)
        listContainerView.snp.makeConstraints { (make) in
            make.top.equalTo(flowCatagoryView.snp.bottom)
            make.leading.trailing.bottom.width.equalToSuperview()
            make.height.equalToSuperview().offset(-flowCatagoryView.flowCatagoryViewHeight)
        }
    }
}

// MARK: 判断哪个scroll可以滑动的逻辑
extension ContainViewController {
    
    func change(key: String) {
        self.listContainerView.change(key: key)
        observeOffsetChange()
    }
    
    func observeOffsetChange() {
        guard let currentScrollView = listContainerView.currentScrollView else { return }
        
        // 解决手势冲突
        scrollView.innterTableView = currentScrollView
        currentScrollView.outerScrollView = scrollView
        
        let task = { [weak self] (scrollView: UIScrollView, oldOffset: CGPoint, newOffset :CGPoint) -> Bool in
            guard let self = self else { return false }
            return self.judgeIsScroll(scrollView: scrollView,
                                      subListView: currentScrollView,
                                      oldOffset: oldOffset,
                                      newOffset: newOffset)
        }
        scrollView.contentOffsetDidChange = task
        currentScrollView.contentOffsetDidChange = task
    }
    
    func judgeIsScroll(scrollView: UIScrollView,
                       subListView: UIScrollView,
                       oldOffset: CGPoint,
                       newOffset: CGPoint) -> Bool {
        
        guard newOffset != oldOffset else { return false }

        // 滑动方向，ture为上滑，false为下拉
        let isScrollUP = newOffset.y > oldOffset.y
        
        // 临界值
        var filterHeight: CGFloat = 0
        if self.headerView.isShowFilterView {
            if !self.headerView.isFilterViewSupportCeiling {
                filterHeight = flowCatagoryView.flowCatagoryViewHeight
            }
        }
        let criticalValue = headerView.bounds.size.height + filterHeight
        
        // 使用旧值判断
        let oldScrollOffsetY: CGFloat
        let oldListOffsetY: CGFloat

        if scrollView === self.scrollView {
            oldScrollOffsetY = oldOffset.y
            oldListOffsetY = subListView.contentOffset.y
        } else {
            oldScrollOffsetY = self.scrollView.contentOffset.y
            oldListOffsetY = oldOffset.y
        }
        
        /*
         主要是以下两个主要条件：
            1. headerVisibleStatus：header的可见状态
            2. isListTop：subListView的y值是否在自身的顶部

         疑问点：
            1. 在即将要进行检测是否可滑动时，先调用了[super setContentOffset: newOffset]，其实不应该先调用，而是等结果再来决定是否。但是尝试了下，动画效果不行，offset变化幅度太大
            1. 使用旧值作为判断是否可以滑动的条件，却没有使用新值判断，需要进一步思考这块
            2. 使用旧值而不是新值来禁止滑动，即使加上了纠偏，但也需要进一步思考
         */
        let headerVisibleStatus: HeaderVisibleStatus
        if oldScrollOffsetY <= 0 {
            headerVisibleStatus = .fullVisible
        } else if oldScrollOffsetY > 0 && oldScrollOffsetY < criticalValue {
            headerVisibleStatus = .partVisible
        } else {
            headerVisibleStatus = .invisible
        }
        let isListTop = oldListOffsetY <= 0

        // 默认scrollView可滑动
        var scrollState: ScrollState = .scrollViewCanScroll
        switch headerVisibleStatus {
        case .fullVisible:
            if !isListTop && !isScrollUP {
                // 当header全部可见时 & tableview的y值没有处于顶部时 & 下拉时
                scrollState = .tableViewCanScroll
            }
        case .partVisible:
            break
        case .invisible:
            if isListTop {
                if isScrollUP {
                    // 当header不显示时 & 当tableview的y值处于顶部时 & 上滑时：tableview可以滑动
                    scrollState = .tableViewCanScroll
                }
            } else {
                // 当header不显示时 & 当tableview的y值没有处于顶部时：tableview可以滑动
                scrollState = .tableViewCanScroll
            }
        }
        
        switch scrollState {
        case .scrollViewCanScroll:
            let scrollCanScroll = scrollView === self.scrollView
            return scrollCanScroll
        case .tableViewCanScroll:
            let tableCanScroll = scrollView === subListView
            return tableCanScroll
        }
    }
}

// MARK: - 筛选器代理方法
extension ContainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        change(key: dataSource[indexPath.row])
    }
}

// MARK: Scroll代理方法
extension ContainViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView === self.scrollView {
            self.headerView.snapTopView(scrollView.contentOffset.y)
            self.headerView.tryCollapse(scrollView.contentOffset.y)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.headerView.tryExpand(scrollView.contentOffset.y)
    }
}

extension ContainViewController: HeaderViewLayoutDelegate {
    
    func headerView(_ headerView: HeaderView, height: CGFloat, isExpand: Bool) {
        if isExpand {
            headerView.snp.updateConstraints { (make) in
                make.height.equalTo(height)
            }
            self.headerView.layout(0)
            scrollView.bounces = false
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
                self.scrollView.setContentOffset(.zero, animated: false)
            } completion: { result in
                self.scrollView.bounces = true
            }
        } else {
            headerView.snp.updateConstraints { (make) in
                make.height.equalTo(height)
            }
            self.scrollView.setContentOffset(CGPoint(x: 0, y: self.headerView.bounds.size.height), animated: false)
            
            var scrollBounds = scrollView.bounds
//            scrollBounds.origin.y = self.headerView.bounds.size.height
            scrollView.bounds = scrollBounds
            
            self.headerView.layout(0)
//            setScrollOffsetY(headerView.heightAboveShortcut)
        }
    }
    
    func headerView(_ headerView: HeaderView, height: CGFloat) {
        headerView.snp.updateConstraints { (make) in
            make.height.equalTo(height)
        }
        scrollView.bounces = false
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        } completion: { result in
            self.scrollView.bounces = true
        }
    }
}

extension ContainViewController: FlowCatagoryViewLayoutDelegate {
    func flowCatagoryView(isShow: Bool) {
        let height: CGFloat
        if isShow {
            height = flowCatagoryView.flowCatagoryViewHeight
        } else {
            height = 0
        }
        flowCatagoryView.snp.updateConstraints { make in
            make.height.equalTo(height)
        }
        listContainerView.snp.updateConstraints { (make) in
            make.height.equalToSuperview().offset(-height)
        }
    }
    
    func flowCatagoryView(isSupportCeiling: Bool) {

        let height: CGFloat
        if isSupportCeiling {
            height = flowCatagoryView.flowCatagoryViewHeight
        } else {
            height = 0
        }
        listContainerView.snp.updateConstraints { (make) in
            make.height.equalToSuperview().offset(-height)
        }
    }
}
