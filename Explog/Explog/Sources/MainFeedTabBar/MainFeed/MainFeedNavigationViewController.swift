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
    
    override func loadView() {
        view = v
    }
    
    @objc func buttonAction(_ sender: UIButton) {
        navigationController?.pushViewController(MainFeedViewController(), animated: true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("프로그래밍 방식으로 UI 구성했을때, frame들 확인해주")
    }
}

extension MainFeedViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeue(MainFeedCollectionViewCell.self, indexPath: indexPath)!
        cell.backgroundColor = .red
        
        return cell
    }
}

