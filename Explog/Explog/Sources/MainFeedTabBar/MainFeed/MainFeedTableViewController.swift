//
//  MainFeedTableViewController.swift
//  Explog
//
//  Created by minjuniMac on 09/10/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
import CaseContainer
import Moya
import BoltsSwift

final class FeedTableViewController: ParallaxTableViewController {
    let provider = MoyaProvider<Feed>()//.(plugins: [NetworkLoggerPlugin(])
    var state: State = .loading {
        didSet {
            switch state {
            case .loading:
                setupUI()
            case .ready:
                tableView.reloadData()
            case .error :
                print("\(#function) 에서 에러발생~~~")
            }
        }
    }
    
    /**
     tableview's tag is used to identify requesting number of continent
     */
    static func createWith(title: String, owner: ParallaxViewDelegate, tag: Int) -> Self {
        let `self` = self.init()
        self.tableView.then {
            $0.delegate = self
            $0.dataSource = self
            $0.register(cell: FeedTableViewCell.self)
            $0.tag = tag
        }
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.delegate = owner
        self.title = title
        return self
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        state = .loading
    }
    
    func setupUI() {
        self.tableView.separatorStyle = .none
        self.tableView.rowHeight = UITableView.automaticDimension
        DispatchQueue.main.async { self.networkServiceWith(continent: self.tableView.tag) }
    }
    
    func networkServiceWith(continent: Int) {
        provider.request(.category(continent: continent)) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let response):
                do {
                    strongSelf.state = .ready(try response.map(FeedModel.self))
                }catch {
                    strongSelf.state = .error
                }
            case.failure(let error) :
                strongSelf.state = .error
                print(error.localizedDescription)
            }
        }
    }
    
    func loadNetwork(continent: Int, query nextpageQuery: String) {
        provider.request(.next(continent: continent, query: nextpageQuery)) { [weak self] result in
            guard let strongSelf = self,
                case .ready(let item) = strongSelf.state else {
                    return
            }
            switch result {
            case .success(let response):
                do {
                    let convertedData = try response.map(FeedModel.self)
                    strongSelf.state = .ready(item + convertedData)
                }catch {
                    print(error.localizedDescription)
                    strongSelf.state = .error
                }
            case .failure(let error):
                strongSelf.state = .error
            }
        }
    }
}

extension FeedTableViewController {
    enum State {
        case loading
        case ready(FeedModel)
        case error
    }
}

// MARK: TableViewDelegate
extension FeedTableViewController {
    
}

// MARK: TableView DataSource
extension FeedTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard case .ready(let item) = state else { return 0 }
        return item.posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeue(FeedTableViewCell.self),
            case .ready(let item) = state else {
                fatalError()
        }
        
        let post = item.posts[indexPath.row]
        cell.configure(title: post.title,
                       imagePath: post.img,
                       startDate: post.startDate,
                       endDate: post.endDate,
                       author: post.author.username)
        
        if let next = item.next,
            indexPath.row == item.posts.count - 1,
            let nextURL = try? next.asURL(),
            let queryOfNextPage = nextURL.query {
            
            
            loadNetwork(continent: tableView.tag, query: queryOfNextPage)
            print("마지막 인덱스")
            
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height/3.6
    }
}
