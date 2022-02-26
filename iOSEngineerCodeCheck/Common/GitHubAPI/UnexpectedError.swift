//
//  UnexpectedError.swift
//  iOSEngineerCodeCheck
//
//  Created by Tomoya Tanaka on 2022/02/26.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation

struct UnexpectedError: Error {}

extension UnexpectedError: LocalizedError {
    var errorDescription: String? {
        return "Unexpected error occured"
    }
}
