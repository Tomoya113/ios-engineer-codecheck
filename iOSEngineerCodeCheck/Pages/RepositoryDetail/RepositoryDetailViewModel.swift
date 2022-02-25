//
//  RepositoryDetailViewModel.swift
//  iOSEngineerCodeCheck
//
//  Created by Tomoya Tanaka on 2022/02/23.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol RepositoryDetailViewModelInputs {
}

protocol RepositoryDetailViewModelOutputs {
    var repository: Driver<GitHubRepositories.Item> { get }
}

protocol RepositoryDetailViewModelType {
    var inputs: RepositoryDetailViewModelInputs { get }
    var outputs: RepositoryDetailViewModelOutputs { get }
}

final class RepositoryDetailViewModel: RepositoryDetailViewModelInputs, RepositoryDetailViewModelOutputs {
    var repository: Driver<GitHubRepositories.Item>

    init(repository: GitHubRepositories.Item) {
        let _repository = BehaviorRelay<GitHubRepositories.Item>(value: repository)
        self.repository = _repository.asDriver()
    }

}

extension RepositoryDetailViewModel: RepositoryDetailViewModelType {
    var inputs: RepositoryDetailViewModelInputs { return self }
    var outputs: RepositoryDetailViewModelOutputs { return self }
}
