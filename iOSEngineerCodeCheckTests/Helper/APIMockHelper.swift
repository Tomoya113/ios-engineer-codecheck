//
//  APIMockHelper.swift
//  iOSEngineerCodeCheckTests
//
//  Created by Tomoya Tanaka on 2022/02/26.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

@testable import Moya

enum APIMockHelper {
    static func generateEndpoint(target: MultiTarget, sampleResponse: EndpointSampleResponse) -> Endpoint {
        return Endpoint(
            url: URL(target: target).absoluteString,
            sampleResponseClosure: {
                sampleResponse
            },
            method: target.method,
            task: target.task,
            httpHeaderFields: target.headers
        )
    }

    static func httpURLResponse(target: MultiTarget, statusCode: Int) -> HTTPURLResponse {
        return HTTPURLResponse(
            url: URL(target: target),
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )!
    }
}
