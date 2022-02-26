//
//  SearchRepositoriesRequest.swift
//  iOSEngineerCodeCheck
//
//  Created by Tomoya Tanaka on 2022/02/22.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation
import Moya

struct SearchRepositoriesRequest: TargetType {

    let searchQuery: String

    init(searchQuery: String) {
        self.searchQuery = searchQuery
    }

    var baseURL: URL {
        return URL(string: Environments.GitHubAPIURL)!
    }

    var path: String {
        return "/search/repositories"
    }

    var method: Moya.Method {
        return .get
    }

    var task: Task {
        return .requestParameters(
            parameters: ["q": searchQuery],
            encoding: URLEncoding.default
        )
    }

    var headers: [String : String]? {
        return nil
    }

    var sampleData: Data {
        return """
        {
            "items": [
            {
                "forks_count": 9438,
                "full_name": "apple/swift",
                "language": "C++",
                "open_issues_count": 511,
                "owner": {
                    "avatar_url": "https://avatars.githubusercontent.com/u/10639145?v=4"
                },
                "stargazers_count": 58786,
                "watchers_count": 58786
            }

            ]
        }
        """.data(using: .utf8)!
    }

    var errorResponseData: Data {
        return """
        {
           "message":"Validation Failed",
           "errors":[
              {
                 "resource":"Search",
                 "field":"q",
                 "code":"missing"
              }
           ],
           "documentation_url":"https://docs.github.com/v3/search"
        }
        """.data(using: .utf8)!
    }

}
