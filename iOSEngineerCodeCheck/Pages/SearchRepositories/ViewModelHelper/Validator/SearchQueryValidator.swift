//
//  SearchQueryValidator.swift
//  iOSEngineerCodeCheck
//
//  Created by Tomoya Tanaka on 2022/02/26.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import RxCocoa
import RxSwift

class SearchQueryValidator {
    enum ValidationResult {
        case valid(searchQuery: String)
        case searchQueryEmpty
    }

    static func validate(_ searchQuery: String) -> ValidationResult {
        if searchQuery.isEmpty {
            return .searchQueryEmpty
        }
        return .valid(searchQuery: searchQuery)
    }
}


extension ObservableType where Element == SearchQueryValidator.ValidationResult {
    func filterValid() -> Observable<String> {
        return flatMap { validationResult -> Observable<String> in
            switch validationResult {
            case .valid(let searchWord):
                return .just(searchWord)
            default:
                return .empty()
            }
        }
    }

    func filterSearchQueryEmpty() -> Observable<Bool> {
        return flatMap { validationResult -> Observable<Bool> in
            switch validationResult {
            case .searchQueryEmpty:
                return .just(true)
            default:
                return .empty()
            }
        }

    }
}
