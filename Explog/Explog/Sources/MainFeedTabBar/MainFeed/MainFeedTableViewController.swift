//
//  MainFeedTableViewController.swift
//  Explog
//
//  Created by minjuniMac on 09/10/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
import CaseContainer

final class FeedTableViewController: ParallaxTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cell: UITableViewCell.self)
    }
}

extension FeedTableViewController {
    
}

extension FeedTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(UITableViewCell.self)!
        cell.textLabel?.text = "\(indexPath)"
        return cell
    }
}
