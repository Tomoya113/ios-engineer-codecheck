//
//  SearchRepositoriesRouter.swift
//  iOSEngineerCodeCheck
//
//  Created by Tomoya Tanaka on 2022/02/23.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation
import UIKit

protocol SearchRepositoriesRouterType {
    func createRepositoryDetailPage(selectedRepository: GitHubRepositories.Item) -> RepositoryDetailViewController
}

final class SearchRepositoriesRouter: SearchRepositoriesRouterType {
    func createRepositoryDetailPage(selectedRepository: GitHubRepositories.Item) -> RepositoryDetailViewController {
        let viewModel = RepositoryDetailViewModel(repository: selectedRepository)
        let repositoryDetailViewController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(identifier: "RepositoryDetail") { coder in
                return RepositoryDetailViewController(coder: coder, viewModel: viewModel)
            }
        return repositoryDetailViewController
    }
}
