//
//  HTTPHeaders.swift
//  Demo1
//
//  Created by Vu Dang on 18/11/25.
//

import Foundation

public typealias HTTPHeaders = [String: String]

public struct HeaderBuilder {
    private var headers: HTTPHeaders = [:]

    public init() {}

    public func add(_ key: String, _ value: String) -> HeaderBuilder {
        var copy = self
        copy.headers[key] = value
        return copy
    }

    public func json() -> HeaderBuilder {
        add("Content-Type", "application/json")
    }

    public func bearer(_ token: String?) -> HeaderBuilder {
        guard let token else { return self }
        return add("Authorization", "Bearer \(token)")
    }

    public func build() -> HTTPHeaders {
        headers
    }
}
