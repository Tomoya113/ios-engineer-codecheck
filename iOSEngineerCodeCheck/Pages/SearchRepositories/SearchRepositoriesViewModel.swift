//
//  SearchRepositoriesViewModel.swift
//  iOSEngineerCodeCheck
//
//  Created by Tomoya Tanaka on 2022/02/22.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol SearchRepositoriesViewModelInputs {
    var searchQuery: AnyObserver<String> { get }
    var selectedItemIndex: AnyObserver<IndexPath> { get }
}

protocol SearchRepositoriesViewModelOutputs {
    var repositories: Driver<[GitHubRepositories.Item]> { get }
    var selectedItem: Driver<GitHubRepositories.Item> { get }
    var hasSearchQueryEmptyError: Driver<Bool> { get }
    var loading: Driver<Bool> { get }
    var error: Driver<Error> { get }
}

protocol SearchRepositoriesViewModelType {
    var inputs: SearchRepositoriesViewModelInputs { get }
    var outputs: SearchRepositoriesViewModelOutputs { get }
}

final class SearchRepositoriesViewModel: SearchRepositoriesViewModelInputs, SearchRepositoriesViewModelOutputs {
    var searchQuery: AnyObserver<String>
    var selectedItemIndex: AnyObserver<IndexPath>

    var repositories: Driver<[GitHubRepositories.Item]>
    var selectedItem: Driver<GitHubRepositories.Item>
    var hasSearchQueryEmptyError: Driver<Bool>
    var loading: Driver<Bool>
    var error: Driver<Error>

    private var disposeBag = DisposeBag()

    init(model: SearchRepositoriesModelType) {
        let _searchQuery = PublishRelay<String>()
        let _selectedItemIndex = PublishRelay<IndexPath>()

        let _repositories = BehaviorRelay<[GitHubRepositories.Item]>(value: [])
        let _selectedItem = PublishRelay<GitHubRepositories.Item>()
        let _hasSearchQueryEmptyValidationError = PublishRelay<Bool>()
        let _loading = PublishRelay<Bool>()
        let _error = PublishRelay<Error>()

        searchQuery = AnyObserver<String> { event in
            guard let searchQuery = event.element else { return }
            _searchQuery.accept(searchQuery)
        }

        selectedItemIndex = AnyObserver<IndexPath> { event in
            guard let selectedItemIndex = event.element else { return }
            _selectedItemIndex.accept(selectedItemIndex)
        }

        repositories = _repositories.asDriver()
        selectedItem = _selectedItem.asDriver(onErrorDriveWith: Driver.empty())
        hasSearchQueryEmptyError = _hasSearchQueryEmptyValidationError.asDriver(onErrorDriveWith: Driver.empty())
        loading = _loading.asDriver(onErrorDriveWith: Driver.empty())
        error = _error.asDriver(onErrorDriveWith: Driver.empty())

        let searchQueryValidationResult = _searchQuery.flatMap { searchQuery in
            return Observable.just(SearchQueryValidator.validate(searchQuery))
        }
        .share()

        let searchRepositoriesResult = searchQueryValidationResult
            .filterValid()
            .flatMap { searchQuery -> Observable<Event<[GitHubRepositories.Item]>> in
                _loading.accept(true)
                return model.fetchRepositories(searchQuery: searchQuery)
                    .asObservable()
                    .materialize()
            }
            .share()

        searchQueryValidationResult
            .filterSearchQueryEmpty()
            .bind(to: _hasSearchQueryEmptyValidationError)
            .disposed(by: disposeBag)

        _selectedItemIndex.map { selectedItemIndex in
            return _repositories.value[selectedItemIndex.row]
        }
        .bind(to: _selectedItem)
        .disposed(by: disposeBag)

        searchRepositoriesResult
            .compactMap { $0.event.element }
            .bind(to: _repositories)
            .disposed(by: disposeBag)

        searchRepositoriesResult
            .compactMap { $0.event.error }
            .bind(to: _error)
            .disposed(by: disposeBag)

        searchRepositoriesResult
            .filter { $0.event.isCompleted == true }
            .map { _ in return false }
            .bind(to: _loading)
            .disposed(by: disposeBag)

    }
}

extension SearchRepositoriesViewModel: SearchRepositoriesViewModelType {
    var inputs: SearchRepositoriesViewModelInputs { return self }
    var outputs: SearchRepositoriesViewModelOutputs { return self }
}
