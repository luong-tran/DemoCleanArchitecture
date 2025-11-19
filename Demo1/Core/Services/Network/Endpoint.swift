//
//  Endpoint.swift
//  Demo1
//
//  Created by Vu Dang on 18/11/25.
//

import Foundation

protocol Endpoint {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var queryItems: [URLQueryItem]? { get }
    var body: Data? { get }
    var timeoutInterval: TimeInterval { get } // Add timeout property
}

extension Endpoint {
    var timeoutInterval: TimeInterval {
        30.0 // Default 30 seconds
    }
    
    var urlRequest: URLRequest? {
        guard var components = URLComponents(url: baseURL.appendingPathComponent(path),
                                             resolvingAgainstBaseURL: false)
        else { return nil }

        components.queryItems = queryItems

        guard let url = components.url else { return nil }

        var req = URLRequest(url: url)
        req.httpMethod = method.rawValue
        req.httpBody = body
        req.timeoutInterval = timeoutInterval // Set timeout

        headers?.forEach { key, value in
            req.addValue(value, forHTTPHeaderField: key)
        }

        return req
    }
}
