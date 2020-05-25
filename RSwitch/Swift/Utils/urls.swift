//
//  urls.swift
//  RSwitch
//
//  Created by hrbrmstr on 5/24/20.
//  Copyright © 2020 Bob Rudis. All rights reserved.
//

import Foundation
import Cocoa
import WebKit

extension URL {
    var queryParameters: QueryParameters { return QueryParameters(url: self) }
}

class QueryParameters {
    let queryItems: [URLQueryItem]
    init(url: URL?) {
        queryItems = URLComponents(string: url?.absoluteString ?? "")?.queryItems ?? []
        print(queryItems)
    }
    subscript(name: String) -> String? {
        return queryItems.first(where: { $0.name == name })?.value
    }
}
