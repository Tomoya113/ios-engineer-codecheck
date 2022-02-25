//
//  GitHubRepositoryItem.swift
//  iOSEngineerCodeCheck
//
//  Created by Tomoya Tanaka on 2022/02/22.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation

struct GitHubRepositories: Decodable {
    let items: [Item]
}

extension GitHubRepositories {
    struct Item: Decodable {
        let forksCount: Int
        let fullName: String
        let language: String?
        let openIssuesCount: Int
        let owner: Owner
        let stargazersCount: Int
        let watchersCount: Int
    }

    struct Owner: Decodable {
        let avatarUrl: String
    }
}

