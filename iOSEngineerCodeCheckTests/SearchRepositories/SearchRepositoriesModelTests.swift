//
//  SearchRepositoriesModelTests.swift
//  iOSEngineerCodeCheckTests
//
//  Created by Tomoya Tanaka on 2022/02/26.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

@testable import iOSEngineerCodeCheck
@testable import RxSwift
import XCTest

class SearchRepositoriesModelTests: XCTestCase {
    let disposeBag = DisposeBag()

    func testFetchRepositories() throws {
        let searchRepositoriesModel = SearchRepositoriesModel(gitHubRepositoriesRepository: GitHubRepositoriesRepositoryMock())

        searchRepositoriesModel
            .fetchRepositories(searchQuery: "swift")
            .subscribe(
                onSuccess: { result in
                    XCTAssertEqual(result.count, GitHubRepositories.expectedData.items.count)
                },
                onFailure: { _ in
                    XCTFail("Expected success")
                }
            )
            .disposed(by: disposeBag)
    }
}
