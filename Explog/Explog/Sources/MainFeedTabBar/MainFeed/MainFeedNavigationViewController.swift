
//
//  MainFeedNavigationViewController.swift
//  Explog
//
//  Created by minjuniMac on 8/21/18.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit


final class MainFeedViewController: BaseViewController {
    lazy var v = MainFeedView(controlBy: self)
    
    override func loadView() { view = v }
    
    static func createWith() -> Self {
        let `self` = self.init()
        self.title = "Feed"
        self.tabBarItem.image = #imageLiteral(resourceName: "mainFeed")
        return self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("프로그래밍 방식으로 UI 구성했을때, frame들 확인해주")
        
    }
    
    deinit {
        print("\(self) has deinitiialzied")
    }
    
    
}

extension MainFeedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(MainFeedCollectionViewCell.self, indexPath: indexPath)!
        cell.setupCellBinding(owner: self)
        cell.lable.text = "\(indexPath)"
        cell.backgroundColor = UIColor.brown
        
        // TableViewCell의 index가 CollectionView의 몇번째 인덱스다 라는것을 알려주기 위해서 적용.
        cell.tableView.tag = indexPath.row
        
        
        return cell
    }
}

extension MainFeedViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        print(cell?.frame)
    }
}

extension MainFeedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}

extension MainFeedViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let newOffSet = scrollView === v.upperScrollView ? scrollView.contentOffset.x * 2 : scrollView.contentOffset.x / 2
        switch scrollView {
        case v.upperScrollView: v.collectionView.contentOffset.x = newOffSet
        case v.collectionView: v.upperScrollView.contentOffset.x = newOffSet
        default : print("테이블뷰의 y콘텐츠 오프셋 ")
        v.coordinate(scrollView.contentOffset)
        
        
        }
        
        print(scrollView.contentOffset)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // UpperScrollView & CollectionView
        let pageWidth = scrollView === v.upperScrollView ? scrollView.bounds.width / 2 : scrollView.bounds.width
        let index = Int(targetContentOffset.pointee.x / pageWidth + 0.5)
        let point = scrollView === v.upperScrollView ? scrollView.contentSize.width / 7 * CGFloat(index) : scrollView.contentSize.width / 6 * CGFloat(index)
        
        // 가로 스크롤
        if scrollView === v.upperScrollView || scrollView === v.collectionView {
            // Tableivew에 적용되는 Point값이 아니라 y값은 무관..
            scrollView.setContentOffset(CGPoint(x: point, y: 0), animated: true)
        }
        
    }
    
    // 드레깅이 끝났을때 호출을 보장하기위함.
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollViewWillEndDragging(scrollView,
                                  withVelocity: scrollView.contentOffset,
                                  targetContentOffset: &scrollView.contentOffset)
    }
}

// ViewController 코드를 줄이기 위해서 UICollectionViewCell에 delgate, DataSource를 주어도 되지만, Parallax사용하기 위해서는 ViewController에 주어야함ㅠㅠ
extension MainFeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let _ = (tableView.cellForRow(at: indexPath) as! InsideTableViewCell).internalIndex
    }
    
}

extension MainFeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 30
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(InsideTableViewCell.self)!
        cell.internalIndex = (
            parentIndex: tableView.tag,
            section: indexPath.section,
            row: indexPath.row)
        cell.backgroundColor = .blue
        cell.textLabel?.text = "\(indexPath)"
        
        return cell
    }
}
