//
//  RemoveAllViewController.swift
//  Explog
//
//  Created by minjuniMac on 07/11/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
import Moya
import BoltsSwift

enum Token: Int {
    case one = 0
    case two
    case three
    case four
    
    var stringToken: String {
        switch self {
        case .one: return "Token c4f9624eb05b2d24bca59006c8cd556873e06c7e"
        case .two: return "ToKen 25c87513fe14b21eb035e2ebf55d8dceccb1cc37"
        case .three: return "Token 3f6342718b6abf8c8fa833d69de9f27604a4fe83"
        case .four: return "Token c7b3e5159ddc49e1660d0dc99d7b14d160b14519"
            
        }
    }
}

enum RemoveAll {
    case post(postPK: Int, tokenType: Token)
}

extension RemoveAll: TargetType {
    var path: String {
        switch self {
        case .post(let postPK, _): return "/post/\(postPK)/update/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .post: return .delete
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Moya.Task {
        switch self {
        case .post: return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .post(_, let tokenType):
            let token: String!
            switch tokenType {
            case .one: token = tokenType.stringToken
            case .two: token = tokenType.stringToken
            case .three: token = tokenType.stringToken
            case .four: token = tokenType.stringToken
            }
            
            return [
                "Authorization": token,
                "Content-Type": "application/json"]
        }
    }
}

enum AllUser {
    case profile(type: Token)
}

extension AllUser: TargetType {
    var path: String {
        switch self {
        case .profile: return "/member/userprofile/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .profile: return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Moya.Task {
        switch self {
        case .profile: return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .profile(let type):
            return [
                "Authorization": type.stringToken,
                "Content-Type": "application/json"]
            
        }
    }
}


final class RemoveAllViewController: UIViewController {
    let provider = MoyaProvider<RemoveAll>(plugins:[NetworkLoggerPlugin()])
    let userProvider = MoyaProvider<AllUser>(plugins:[NetworkLoggerPlugin()])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    enum State {
        case loading
        case ready(UserModel)
    }
    
    var state: State = .loading {
        didSet {
            switch state {
            case .loading: break
            case .ready: break
            }
        }
    }
    
    var semafore = DispatchSemaphore(value: 0)
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear 시작")
        userData(type: Token.three)
            .continueWith { [weak self] (task) -> [Int] in
                guard let result = task.result else {
                    return [Int]()
                }
                
                return result.posts.compactMap{ $0.pk } ;
            }
            .continueWith { [weak self] (task) -> Void in
                guard let strongSelf = self, let pks = task.result else {
                    return
                }
                
                print(pks)
                for pk in pks {
                    
                    strongSelf
                        .provider
                        .request(RemoveAll.post(postPK: pk, tokenType: Token.three), completion: { result in
                            switch result {
                            case .success(let response):
                                switch (200...299) ~= response.statusCode {
                                case true: print("삭제 성공: \(response.statusCode), pk: \(pk)")
                                case false: print("삭제 실패: \(response.statusCode), pk: \(pk)")
                                }
                            case .failure(let error): print("error: \(error), 뭐지...........-----------------------------------------")
                            }
                            
                        })
                    
                    print("실행중...: pk: \(pk)")
                }
        }
    }
    
    func removeAll() {
        
    }
    
    
    func userData(type: Token) -> BoltsSwift.Task<UserModel> {
        let source = TaskCompletionSource<UserModel>()
        
        userProvider.request(.profile(type: type)) { [weak self] (result) in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case .success(let response):
                switch (200...299) ~= response.statusCode {
                case true :
                    do {
                        let model = try response.map(UserModel.self)
                        strongSelf.state = .ready(model)
                        source.set(result: model)
                    }catch {
                        source.set(error: NSError(domain: "User 변환 실패......", code: 1, userInfo: nil))
                        
                        
                    }
                    
                case false :
                    source.set(error: NSError(domain: "User 응답 애러--------------------------------------------------------", code: 2, userInfo: nil))
                }
            case .failure(let error):
                source.set(error: NSError(domain: "User 요청 애러--------------------------------------------------------", code: 3, userInfo: nil))
            }
        }
        return source.task
    }
}
