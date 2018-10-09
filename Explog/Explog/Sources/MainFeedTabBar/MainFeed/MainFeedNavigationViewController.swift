
//
//  MainFeedNavigationViewController.swift
//  Explog
//
//  Created by minjuniMac on 8/21/18.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
import CaseContainer

final class FeedContainerViewController: CaseContainerViewController {
    required init() {
        super.init()
        let titles: [String] = ["Asia", "Europe", "North America", "South America", "Africa", "Austrailia"]
        
        viewContorllers = titles.compactMap {
            [weak self] (title: String) -> ParallaxTableViewController? in
            guard let strongSelf = self else {
                return nil
            }
            let childVC = FeedTableViewController()
            childVC.title = title
            childVC.delegate = strongSelf
            return childVC
        }
        appearence = Appearance(
            headerViewHegiht: UIScreen.mainHeight/3,
            tabScrollViewHeight: 50,
            indicatorColor: .thisApp,
            tabButtonColor: (normal: .gray, highLight: .black))
    }
    
    static func createWith() -> Self {
        let `self` = self.init()
        self.title = "Feed"
        self.tabBarItem.image = #imageLiteral(resourceName: "globe")
        return self
    }
    
    let images: [UIImage] = [#imageLiteral(resourceName: "South America"), #imageLiteral(resourceName: "Africa"), #imageLiteral(resourceName: "North America"), #imageLiteral(resourceName: "Europe"), #imageLiteral(resourceName: "Austrailia"), #imageLiteral(resourceName: "Asia")]
    
    lazy var headerImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = images[0]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBinding()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func setupUI() {
        navigationController?.navigationBar.isHidden = true
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
    func caseContainer(caseContainerViewController: CaseContainerViewController, scrollViewWillBeginDragging scrollView: UIScrollView) {}
    func caseContainer(caseContainerViewController: CaseContainerViewController, index: Int, scrollViewDidEndDragging scrollView: UIScrollView) {}
    func caseContainer(caseContainerViewController: CaseContainerViewController, didSelectTabButton tabButton: TabButton, prevIndex: Int, index: Int) {}
    func caseContainer(caseContainerViewController: CaseContainerViewController, progress: CGFloat, index: Int, scrollViewDidScroll scrollView: UIScrollView) {
        headerImageView.layer.opacity = Float( 1 - progress )
    }
    
    func caseContainer(caseContainerViewController: CaseContainerViewController, index: Int, scrollViewDidEndDecelerating scrollView: UIScrollView) {
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
