//
//  SearchView.swift
//  Explog
//
//  Created by minjuniMac on 8/21/18.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
import Localize_Swift

final class SearchView: BaseView<SearchViewController> {
    var searchTableView = UITableView().then {
        $0.backgroundColor = .white
        $0.register(cell: SearchCell.self)
        $0.separatorStyle = .none
        $0.contentInsetAdjustmentBehavior = .automatic
        $0.insetsContentViewsToSafeArea = true
    }
    
    lazy var searchController = UISearchController(searchResultsController: nil).then {
        $0.searchResultsUpdater = vc
        $0.obscuresBackgroundDuringPresentation = false
        $0.searchBar.showsCancelButton = true
        $0.searchBar.isTranslucent = false
        $0.searchBar.barTintColor = .white
        $0.hidesNavigationBarDuringPresentation = false
    }
    
    struct UI {
        static var tableViewHeight: CGFloat = UIScreen.mainHeight / 4.0
    }
    
    override func setupUI() {
        addSubviews([searchTableView])
        
        searchTableView
            .topAnchor(to: topAnchor)
            .leadingAnchor(to: leadingAnchor)
            .trailingAnchor(to: trailingAnchor)
            .bottomAnchor(to: bottomAnchor)
            .activateAnchors()
    }
    
    override func setupBinding() {
        searchTableView.delegate = vc
        searchTableView.dataSource = vc
        setupNavigationBar()
        setupSearchBarUI()
    }
    
    func setupNavigationBar() {
        vc.navigationItem.hidesSearchBarWhenScrolling = false
        vc.navigationItem.titleView = searchController.searchBar
        searchController.hidesNavigationBarDuringPresentation = false
        vc.definesPresentationContext = true
        vc.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        vc.navigationController?.navigationBar.barTintColor = .appStyle
        vc.navigationController?.navigationBar.barStyle = .black   
    }
    
    // placeHolder Color, text Color black
    func setupSearchBarUI() {
        searchController.searchBar.placeholder = "Search trip in the world".localized()
        if let cancelButton = searchController.searchBar.value(forKey: "cancelButton") as? UIButton {
            cancelButton.setTitle("Cancel".localized(), for: .normal)
        }
    }
    
    func setup(footerView: ViewControllerStateView?) {
        switch footerView?.stateType {
        case .empty?, .error?:  searchTableView.isScrollEnabled = false
        default:                searchTableView.isScrollEnabled = true
        }
        searchTableView.tableFooterView = footerView
    }
    
    func retrieve(word: String) {
        searchController.searchBar.text = word
        endEditing(true)
    }
}
