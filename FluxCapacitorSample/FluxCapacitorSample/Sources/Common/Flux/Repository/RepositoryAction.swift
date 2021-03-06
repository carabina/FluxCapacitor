//
//  RepositoryAction.swift
//  FluxCapacitorSample
//
//  Created by marty-suzuki on 2017/08/02.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import Foundation
import FluxCapacitor
import GithubKit

final class RepositoryAction: Actionable {
    typealias DispatchValueType = Dispatcher.Repository
    
    private let session: ApiSession
    
    init(session: ApiSession = .shared) {
        self.session = session
    }
    
    func fetchRepositories(withUserId id: String, after: String?) {
        invoke(.isRepositoryFetching(true))
        let request = UserNodeRequest(id: id, after: after)
        let task = session.send(request) { [weak self] in
            switch $0 {
            case .success(let value):
                self?.invoke(.lastPageInfo(value.pageInfo))
                self?.invoke(.addRepositories(value.nodes))
                self?.invoke(.repositoryTotalCount(value.totalCount))
            case .failure:
                break
            }
            self?.invoke(.isRepositoryFetching(false))
        }
        invoke(.lastTask(task))
    }
}
