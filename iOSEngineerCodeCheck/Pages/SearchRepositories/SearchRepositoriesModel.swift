//
//  SearchRepositoriesModel.swift
//  iOSEngineerCodeCheck
//
//  Created by Tomoya Tanaka on 2022/02/22.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation
import RxSwift

protocol SearchRepositoriesModelType {
    func fetchRepositories(searchQuery: String) -> Single<[GitHubRepositories.Item]>
}

final class SearchRepositoriesModel: SearchRepositoriesModelType {
    private let gitHubRepositoriesRepository: GitHubRepositoriesRepositoryType

    init(gitHubRepositoriesRepository: GitHubRepositoriesRepositoryType) {
        self.gitHubRepositoriesRepository = gitHubRepositoriesRepository
    }

    func fetchRepositories(searchQuery: String) -> Single<[GitHubRepositories.Item]> {
        gitHubRepositoriesRepository
            .fetchRepositories(searchQuery: searchQuery)
            .map { response in
                return response.items
            }
    }

}
