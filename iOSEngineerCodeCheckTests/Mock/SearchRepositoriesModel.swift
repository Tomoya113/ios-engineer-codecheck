//
//  SearchRepositoriesModel.swift
//  iOSEngineerCodeCheckTests
//
//  Created by Tomoya Tanaka on 2022/02/26.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation
@testable import iOSEngineerCodeCheck
@testable import RxSwift

final class SearchRepositoriesModelMock: SearchRepositoriesModelType {
    func fetchRepositories(searchQuery: String) -> Single<[GitHubRepositories.Item]> {
        return .just(GitHubRepositories.expectedData.items)
    }
}
