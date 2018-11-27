
//
//  MainFeedNavigationViewController.swift
//  Explog
//
//  Created by minjuniMac on 8/21/18.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
import CaseContainer
import Localize_Swift


final class FeedContainerViewController: CaseContainerViewController {
    required init() {
        super.init()
        let titles: [String] = [
            "Asia".localized(),
            "Europe".localized(),
            "North America".localized(),
            "South America".localized(),
            "Africa".localized(),
            "Oceania".localized()
        ]
        viewContorllers = titles
            .enumerated()
            .compactMap { [weak self] (tag: Int, title: String) -> ParallaxTableViewController? in
                guard let self = self else {
                    return nil
                }
                return FeedTableViewController.createWith(
                    title: title,
                    owner: self,
                    tag: tag+Int(1) )
        }
        appearence = Appearance(
            headerViewHegiht: UIScreen.mainHeight/3.5,
            tabScrollViewHeight: 50,
            indicatorColor: .appStyle,
            tabButtonColor: (normal: .gray, highLight: .black))
    }
    
    static func create() -> UINavigationController {
        let `self` = self.init()
        self.title = "Feed".localized()
        self.tabBarItem.image = #imageLiteral(resourceName: "globe")
        let naviController = UINavigationController(rootViewController: self)
        naviController.setNavigationBarHidden(true, animated: false)
        return naviController
    }
    
    let images: [UIImage] = [#imageLiteral(resourceName: "torii-gate-512px"), #imageLiteral(resourceName: "eiffel-tower-512px"), #imageLiteral(resourceName: "new-york"), #imageLiteral(resourceName: "andes"), #imageLiteral(resourceName: "giraffe"), #imageLiteral(resourceName: "sydney-opera-house")]
    
    lazy var headerImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = images[0]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func setupUI() {
        navigationController?.navigationBar.isHidden = true
        navigationItem.title = nil
        headerView.addSubview(headerImageView)
        headerImageView
            .topAnchor(to: headerView.topAnchor)
            .bottomAnchor(to: headerView.bottomAnchor)
            .leadingAnchor(to: headerView.leadingAnchor)
            .trailingAnchor(to: headerView.trailingAnchor)
            .activateAnchors()
    }
    
    func setupBinding() {
        delegate = self
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }   
    
    required init(maintain: [UIViewController], appearence: Appearance) {
        fatalError("init(maintain:appearence:) has not been implemented")
    }
}

extension FeedContainerViewController: CaseContainerDelegate {
    func caseContainer(
        caseContainerViewController: CaseContainerViewController,
        didSelectTabButton tabButton: TabButton,
        prevIndex: Int, index: Int) {
        headerImageView.image = images[index]
    }
    func caseContainer(
        caseContainerViewController: CaseContainerViewController,
        progress: CGFloat,
        index: Int,
        scrollViewDidScroll scrollView: UIScrollView) {
        headerImageView.layer.opacity = Float( 1 - progress )
    }
    
    func caseContainer(
        caseContainerViewController: CaseContainerViewController,
        index: Int,
        scrollViewDidEndDecelerating scrollView: UIScrollView) {
        guard index < images.count else {
            return
        }
        headerImageView.image = images[index]
        headerImageView.layer.opacity = 1
    }
    
    
    func caseContainer(parallaxHeader progress: CGFloat) {
        headerImageView.layer.opacity = Float( 1 - progress )
        
    }
}
