//
//  SearchRepositoriesViewModelTests.swift
//  iOSEngineerCodeCheckTests
//
//  Created by Tomoya Tanaka on 2022/02/26.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

@testable import iOSEngineerCodeCheck
@testable import RxSwift
@testable import RxTest
import XCTest

class SearchRepositoriesViewModelTests: XCTestCase {

    let dependency = Dependency()

    func testSearchQueryInputValid() throws {
        let searchQueryEvent = dependency.testScheduler.createHotObservable([
            Recorded.next(1, "swift")
        ]).asObservable()

        let repositoriesObserver = dependency.testScheduler.createObserver([GitHubRepositories.Item].self)
        let loadingObserver = dependency.testScheduler.createObserver(Bool.self)


        searchQueryEvent
            .bind(to: dependency.testTarget.searchQuery)
            .disposed(by: dependency.disposeBag)

        dependency.testTarget.outputs.repositories
            .asObservable()
            .bind(to: repositoriesObserver)
            .disposed(by: dependency.disposeBag)

        dependency.testTarget.outputs.loading
            .asObservable()
            .bind(to: loadingObserver)
            .disposed(by: dependency.disposeBag)

        dependency.testScheduler.start()

        let repositoriesResult = repositoriesObserver.events.map { $0.value.element }
        let loadingResult = loadingObserver.events.map { $0.value.element }

        XCTAssertEqual(repositoriesResult.last??.count, GitHubRepositories.expectedData.items.count)
        XCTAssertEqual(loadingResult, [true, false])
    }

    func testSearchQueryInputInvalid() throws {
        let searchQueryEvent = dependency.testScheduler.createHotObservable([
            Recorded.next(1, "")
        ]).asObservable()

        let repositoriesObserver = dependency.testScheduler.createObserver([GitHubRepositories.Item].self)
        let loadingObserver = dependency.testScheduler.createObserver(Bool.self)
        let hasSearchQueryEmptyErrorObserver = dependency.testScheduler.createObserver(Bool.self)

        searchQueryEvent
            .bind(to: dependency.testTarget.searchQuery)
            .disposed(by: dependency.disposeBag)

        dependency.testTarget.outputs.repositories
            .asObservable()
            .bind(to: repositoriesObserver)
            .disposed(by: dependency.disposeBag)

        dependency.testTarget.outputs.loading
            .asObservable()
            .bind(to: loadingObserver)
            .disposed(by: dependency.disposeBag)

        dependency.testTarget.outputs.hasSearchQueryEmptyError
            .asObservable()
            .bind(to: hasSearchQueryEmptyErrorObserver)
            .disposed(by: dependency.disposeBag)

        dependency.testScheduler.start()

        let repositoriesResult = repositoriesObserver.events.map { $0.value.element }
        let loadingResult = loadingObserver.events.map { $0.value.element }
        let hasSearchQueryEmptyErrorResult = hasSearchQueryEmptyErrorObserver.events.map { $0.value.element }

        XCTAssertEqual(repositoriesResult.count, 1)
        XCTAssertEqual(loadingResult, [])
        XCTAssertEqual(hasSearchQueryEmptyErrorResult, [true])

    }

    func testSelectedItemIndexSuccess() throws {
        let searchQueryEvent = dependency.testScheduler.createHotObservable([
            Recorded.next(0, "swift")
        ]).asObservable()

        let selectedItemIndexEvent = dependency.testScheduler.createHotObservable([
            Recorded.next(1, IndexPath(row: GitHubRepositories.expectedData.items.count - 1, section: 1))
        ]).asObservable()

        let selectedItemObserver = dependency.testScheduler.createObserver(GitHubRepositories.Item.self)

        searchQueryEvent
            .bind(to: dependency.testTarget.inputs.searchQuery)
            .disposed(by: dependency.disposeBag)

        selectedItemIndexEvent
            .bind(to: dependency.testTarget.inputs.selectedItemIndex)
            .disposed(by: dependency.disposeBag)

        dependency.testTarget.outputs.selectedItem
            .asObservable()
            .bind(to: selectedItemObserver)
            .disposed(by: dependency.disposeBag)

        dependency.testScheduler.start()

        let selectedItemResult = selectedItemObserver.events.map { $0.value.element }

        XCTAssertEqual(selectedItemResult.count, 1)

    }
}


extension SearchRepositoriesViewModelTests {
    struct Dependency {
        let disposeBag: DisposeBag
        let testScheduler: TestScheduler
        let searchRepositoriesModelMock: SearchRepositoriesModelMock
        let testTarget: SearchRepositoriesViewModel

        init() {
            disposeBag = DisposeBag()
            testScheduler = TestScheduler(initialClock: 0)
            searchRepositoriesModelMock = SearchRepositoriesModelMock()
            testTarget = SearchRepositoriesViewModel(model: searchRepositoriesModelMock)
        }
    }
}
