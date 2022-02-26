//
//  GitHubRepositories.swift
//  iOSEngineerCodeCheckTests
//
//  Created by Tomoya Tanaka on 2022/02/26.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation
@testable import iOSEngineerCodeCheck

extension GitHubRepositories {
    static var expectedData: GitHubRepositories {
        return GitHubRepositories(items: [
            GitHubRepositories.Item(
                forksCount: 9_438,
                fullName: "apple/swift",
                language: "C++",
                openIssuesCount: 511,
                owner: GitHubRepositories.Owner(
                    avatarUrl: "https://avatars.githubusercontent.com/u/10639145?v=4"
                ),
                stargazersCount: 58_786,
                watchersCount: 58_786
            )
        ])
    }
}
