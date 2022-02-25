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

    private var disposeBag = DisposeBag()

    init(model: SearchRepositoriesModelType) {
        let _searchQuery = PublishRelay<String>()
        let _selectedItemIndex = PublishRelay<IndexPath>()
        let _repositories = BehaviorRelay<[GitHubRepositories.Item]>(value: [])
        let _selectedItem = PublishRelay<GitHubRepositories.Item>()

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

        let searchResult = _searchQuery.flatMap { searchQuery -> Single<[GitHubRepositories.Item]> in
            return model.fetchRepositories(searchQuery: searchQuery)
        }
        .share()

        _selectedItemIndex.map { selectedItemIndex in
            return _repositories.value[selectedItemIndex.row]
        }
        .bind(to: _selectedItem)
        .disposed(by: disposeBag)

        searchResult
            .bind(to: _repositories)
            .disposed(by: disposeBag)

    }

}

extension SearchRepositoriesViewModel: SearchRepositoriesViewModelType {
    var inputs: SearchRepositoriesViewModelInputs { return self }
    var outputs: SearchRepositoriesViewModelOutputs { return self }
}
