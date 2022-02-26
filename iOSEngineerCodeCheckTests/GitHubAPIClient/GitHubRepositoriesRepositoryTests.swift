//
//  GitHubRepositoriesRepositoryTests.swift
//  iOSEngineerCodeCheckTests
//
//  Created by Tomoya Tanaka on 2022/02/26.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

@testable import iOSEngineerCodeCheck
@testable import Moya
@testable import RxSwift
import XCTest

class GitHubRepositoriesRepositoryTests: XCTestCase {
    func testFetchRepositories() throws {
        let searchQuery = "swift"
        let disposeBag = DisposeBag()
        let searchRepositories = SearchRepositoriesRequest(searchQuery: searchQuery)
        let endpointClosure = { [searchRepositories] (target: MultiTarget) -> Endpoint in
            return APIMockHelper.generateEndpoint(
                target: target,
                sampleResponse: .response(
                    APIMockHelper.httpURLResponse(target: target, statusCode: 200),
                    searchRepositories.sampleData
                )
            )
        }
        let stubbingProvider = MoyaProvider<MultiTarget>(endpointClosure: endpointClosure, stubClosure: MoyaProvider.immediatelyStub)

        let apiClient = GitHubAPIClient(provider: stubbingProvider)
        let gitHubSearchRepositoriesRepository = GitHubRepositoriesRepository(apiClient: apiClient)

        gitHubSearchRepositoriesRepository.fetchRepositories(searchQuery: searchQuery)
            .subscribe(
                onSuccess: { result in
                    XCTAssertEqual(result.items.count, GitHubRepositories.expectedData.items.count)
                },
                onFailure: { _ in
                    XCTFail("Expected success")
                }
            )
            .disposed(by: disposeBag)

    }

}
