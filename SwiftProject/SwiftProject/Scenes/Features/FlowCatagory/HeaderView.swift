//
//  HeaderView.swift
//  UDCCatalog
//
//  Created by Ryan on 2021/7/5.
//  Copyright © 2021 Ryan. All rights reserved.
//

import Foundation
import SnapKit

protocol HeaderViewLayoutDelegate: AnyObject {
    func headerView(_ headerView: HeaderView, height: CGFloat)
    func headerView(_ headerView: HeaderView, height: CGFloat, isExpand: Bool)
}

class HeaderView: UIView {
    private let changeHeightButton = UIButton()
    private let removeFilterButton = UIButton()
    private let filterCeilingButton = UIButton()

    var isShowFilterView = true
    var isFilterViewSupportCeiling = true
    var isExpanded = false
    weak var delegate: (HeaderViewLayoutDelegate & FlowCatagoryViewLayoutDelegate)?
    var headerViewHeight: CGFloat = 600

    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .red

        addSubview(changeHeightButton)
        changeHeightButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(5)
        }
        changeHeightButton.setTitle("改变高度", for: .normal)
        changeHeightButton.setTitleColor(UIColor.black, for: .normal)
        changeHeightButton.addTarget(self, action: #selector(changeHeight), for: .touchUpInside)
        
        addSubview(removeFilterButton)
        removeFilterButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(10)
            make.top.equalTo(changeHeightButton.snp.bottom).offset(5)
        }
        removeFilterButton.setTitle("移除filter", for: .normal)
        removeFilterButton.setTitleColor(UIColor.black, for: .normal)
        removeFilterButton.addTarget(self, action: #selector(removeFilter), for: .touchUpInside)
        
        addSubview(filterCeilingButton)
        filterCeilingButton.setTitleColor(UIColor.black, for: .normal)
        filterCeilingButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(10)
            make.top.equalTo(removeFilterButton.snp.bottom).offset(5)
        }
        filterCeilingButton.setTitle("支持吸顶", for: .normal)
        filterCeilingButton.addTarget(self, action: #selector(filterCeiling), for: .touchUpInside)
        
        changeHeightButton.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        removeFilterButton.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        filterCeilingButton.titleLabel?.font = UIFont.systemFont(ofSize: 10)
    }

    func snapTopView(_ y: CGFloat) {
        guard !isExpanded, y <= 0 else { return }
        changeHeightButton.snp.updateConstraints { (make) in
            make.top.equalToSuperview().offset(y + 5)
        }
    }
    
    func layout(_ y: CGFloat) {
        changeHeightButton.snp.updateConstraints { (make) in
            make.top.equalToSuperview().offset(y + 5)
        }
    }
    
    func tryExpand(_ y: CGFloat) {
        guard !isExpanded else { return }
        if y < -80 {
            headerViewHeight = 200
            isExpanded = true
            delegate?.headerView(self, height: headerViewHeight, isExpand: isExpanded)
        }
    }
    
    func tryCollapse(_ y: CGFloat) {
        guard isExpanded else { return }
        if isExpanded && y >= self.bounds.size.height {
            headerViewHeight = 100
            isExpanded = false
            delegate?.headerView(self, height: headerViewHeight, isExpand: isExpanded)
        }
    }

    @objc
    private func changeHeight() {
        let newHeight: CGFloat
        if headerViewHeight == 100 {
            newHeight = 200
        } else {
            newHeight = 100
        }
        headerViewHeight = newHeight
        delegate?.headerView(self, height: newHeight)
    }
    
    @objc
    private func removeFilter() {
        isShowFilterView = !isShowFilterView
        delegate?.flowCatagoryView(isShow: isShowFilterView)
    }
    
    @objc
    private func filterCeiling() {
        isFilterViewSupportCeiling = !isFilterViewSupportCeiling
        delegate?.flowCatagoryView(isSupportCeiling: isFilterViewSupportCeiling)
    }
}
