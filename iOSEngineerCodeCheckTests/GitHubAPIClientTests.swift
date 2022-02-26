//
//  GitHubAPIClientTests.swift
//  iOSEngineerCodeCheckTests
//
//  Created by Tomoya Tanaka on 2022/02/26.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

@testable import iOSEngineerCodeCheck
@testable import Moya
@testable import RxSwift
import XCTest

class GitHubAPIClientTests: XCTestCase {
    let disposeBag = DisposeBag()
    let searchRepositories = SearchRepositoriesRequest(searchQuery: "swift")
    func testAPIResponseSuccess() {
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

        apiClient.send(targetType: searchRepositories, responseType: GitHubRepositories.self)
            .subscribe(
                onSuccess: { result in
                    XCTAssertEqual(result.items.count, 1)
                },
                onFailure: { error in
                    XCTFail("Test failed")
                }
            )
            .disposed(by: disposeBag)
    }

    func testAPIResponseFailure() {
        let endpointClosure = { [searchRepositories] (target: MultiTarget) -> Endpoint in
            return APIMockHelper.generateEndpoint(
                target: target,
                sampleResponse: .networkResponse(422, searchRepositories.errorResponseData)
            )
        }
        let stubbingProvider = MoyaProvider<MultiTarget>(endpointClosure: endpointClosure, stubClosure: MoyaProvider.immediatelyStub)

        let apiClient = GitHubAPIClient(provider: stubbingProvider)

        apiClient.send(targetType: searchRepositories, responseType: GitHubRepositories.self)
            .subscribe(
                onSuccess: { result in
                    XCTFail("Test failed")
                },
                onFailure: { error in
                    if let moyaError = error as? MoyaError {
                        XCTAssertEqual(moyaError.localizedDescription, "Status code didn\'t fall within the given range.")
                    } else {
                        XCTFail("UnexpectedError occured")
                    }
                }
            )
            .disposed(by: disposeBag)
    }

    func testNetworkError() {
        let endpointClosure = { (target: MultiTarget) -> Endpoint in
            return APIMockHelper.generateEndpoint(
                target: target,
                sampleResponse: .networkError(NSError(domain: "CanNotConnectToHost", code: -1_004, userInfo: nil))
            )
        }
        let stubbingProvider = MoyaProvider<MultiTarget>(endpointClosure: endpointClosure, stubClosure: MoyaProvider.immediatelyStub)

        let apiClient = GitHubAPIClient(provider: stubbingProvider)

        apiClient.send(targetType: searchRepositories, responseType: GitHubRepositories.self)
            .subscribe(
                onSuccess: { result in
                    XCTFail("expected failure")
                },
                onFailure: { error in
                    if let moyaError = error as? MoyaError {
                        switch moyaError {
                        case .underlying(let nsError as NSError, _):
                            XCTAssertEqual(nsError.code, -1_004)
                        default:
                            XCTFail("Underlying error is expected")
                        }
                    } else {
                        XCTFail("UnexpectedError occured")
                    }
                }
            )
            .disposed(by: disposeBag)
    }
}

