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

}
