//
//  GitHubAPIClient.swift
//  iOSEngineerCodeCheck
//
//  Created by Tomoya Tanaka on 2022/02/22.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation
import Moya
import RxSwift

protocol GitHubAPIClientType {
    func send<Response: Decodable>(targetType: TargetType, responseType: Response.Type) -> Single<Response>
}

final class GitHubAPIClient: GitHubAPIClientType {

    let provider: MoyaProvider<MultiTarget>

    init(
        provider: MoyaProvider<MultiTarget>
    ) {
        self.provider = provider
    }

    func send<Response: Decodable>(targetType: TargetType, responseType: Response.Type) -> Single<Response> {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return provider.rx.request(MultiTarget(targetType))
            .filterSuccessfulStatusCodes()
            .map(Response.self, using: decoder)
            .catch { error in
                return Single.error(error)
            }
    }
}
