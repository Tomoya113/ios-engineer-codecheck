//
//  GitHubRepositoriesRepository.swift
//  iOSEngineerCodeCheck
//
//  Created by Tomoya Tanaka on 2022/02/22.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation
import Moya
import RxSwift

protocol GitHubRepositoriesRepositoryType {
    func fetchRepositories(searchQuery: String) -> Single<GitHubRepositories>
}

final class GitHubRepositoriesRepository: GitHubRepositoriesRepositoryType {
    private let apiClient: GitHubAPIClientType

    init(apiClient: GitHubAPIClientType) {
        self.apiClient = apiClient
    }

    func fetchRepositories(searchQuery: String) -> Single<GitHubRepositories> {
        let targetType = SearchRepositoriesRequest(searchQuery: searchQuery)
        return apiClient.send(targetType: targetType, responseType: GitHubRepositories.self)
    }
}
