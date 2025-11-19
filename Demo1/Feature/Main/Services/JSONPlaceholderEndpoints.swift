//
//  JSONPlaceholderEndpoints.swift
//  Demo1
//
//  Created by Vu Dang on 18/11/25.
//

import Foundation

// MARK: - Endpoint Group
enum JSONPlaceholderEndpointGroup: EndpointGroup {
    typealias T = GetPostsEndpoint
    static var base: URL {
        URL(string: "https://jsonplaceholder.typicode.com")!
    }
}

// MARK: - GET Endpoints
struct GetPostsEndpoint: Endpoint {
    var baseURL: URL { JSONPlaceholderEndpointGroup.base }
    var path: String { "/posts" }
    var method: HTTPMethod { .get }
    var headers: HTTPHeaders? { HeaderBuilder().json().build() }
    var queryItems: [URLQueryItem]? { nil }
    var body: Data? { nil }
}

struct GetPostEndpoint: Endpoint {
    let postId: Int
    
    var baseURL: URL { JSONPlaceholderEndpointGroup.base }
    var path: String { "/posts/\(postId)" }
    var method: HTTPMethod { .get }
    var headers: HTTPHeaders? { HeaderBuilder().json().build() }
    var queryItems: [URLQueryItem]? { nil }
    var body: Data? { nil }
}

// MARK: - POST Endpoint
struct CreatePostEndpoint: Endpoint {
    let request: CreatePostRequest
    
    var baseURL: URL { JSONPlaceholderEndpointGroup.base }
    var path: String { "/posts" }
    var method: HTTPMethod { .post }
    var headers: HTTPHeaders? { HeaderBuilder().json().build() }
    var queryItems: [URLQueryItem]? { nil }
    var body: Data? { request.toJSONData() }
}

// MARK: - PUT Endpoint
struct UpdatePostEndpoint: Endpoint {
    let postId: Int
    let request: CreatePostRequest
    
    var baseURL: URL { JSONPlaceholderEndpointGroup.base }
    var path: String { "/posts/\(postId)" }
    var method: HTTPMethod { .put }
    var headers: HTTPHeaders? { HeaderBuilder().json().build() }
    var queryItems: [URLQueryItem]? { nil }
    var body: Data? { request.toJSONData() }
}

// MARK: - PATCH Endpoint
struct PatchPostEndpoint: Endpoint {
    let postId: Int
    let request: UpdatePostRequest
    
    var baseURL: URL { JSONPlaceholderEndpointGroup.base }
    var path: String { "/posts/\(postId)" }
    var method: HTTPMethod { .patch }
    var headers: HTTPHeaders? { HeaderBuilder().json().build() }
    var queryItems: [URLQueryItem]? { nil }
    var body: Data? { request.toJSONData() }
}

// MARK: - DELETE Endpoint
struct DeletePostEndpoint: Endpoint {
    let postId: Int
    
    var baseURL: URL { JSONPlaceholderEndpointGroup.base }
    var path: String { "/posts/\(postId)" }
    var method: HTTPMethod { .delete }
    var headers: HTTPHeaders? { HeaderBuilder().json().build() }
    var queryItems: [URLQueryItem]? { nil }
    var body: Data? { nil }
}


// MARK: - User GET Endpoints
struct GetUsersEndpoint: Endpoint {
    var baseURL: URL { JSONPlaceholderEndpointGroup.base }
    var path: String { "/users" }
    var method: HTTPMethod { .get }
    var headers: HTTPHeaders? { HeaderBuilder().json().build() }
    var queryItems: [URLQueryItem]? { nil }
    var body: Data? { nil }
}

struct GetUserEndpoint: Endpoint {
    let userId: Int
    
    var baseURL: URL { JSONPlaceholderEndpointGroup.base }
    var path: String { "/users/\(userId)" }
    var method: HTTPMethod { .get }
    var headers: HTTPHeaders? { HeaderBuilder().json().build() }
    var queryItems: [URLQueryItem]? { nil }
    var body: Data? { nil }
}

// MARK: - User POST Endpoint
struct CreateUserEndpoint: Endpoint {
    let request: CreateUserRequest
    
    var baseURL: URL { JSONPlaceholderEndpointGroup.base }
    var path: String { "/users" }
    var method: HTTPMethod { .post }
    var headers: HTTPHeaders? { HeaderBuilder().json().build() }
    var queryItems: [URLQueryItem]? { nil }
    var body: Data? { request.toJSONData() }
}

// MARK: - User PUT Endpoint
struct UpdateUserEndpoint: Endpoint {
    let userId: Int
    let request: CreateUserRequest
    
    var baseURL: URL { JSONPlaceholderEndpointGroup.base }
    var path: String { "/users/\(userId)" }
    var method: HTTPMethod { .put }
    var headers: HTTPHeaders? { HeaderBuilder().json().build() }
    var queryItems: [URLQueryItem]? { nil }
    var body: Data? { request.toJSONData() }
}

// MARK: - User PATCH Endpoint
struct PatchUserEndpoint: Endpoint {
    let userId: Int
    let request: UpdateUserRequest
    
    var baseURL: URL { JSONPlaceholderEndpointGroup.base }
    var path: String { "/users/\(userId)" }
    var method: HTTPMethod { .patch }
    var headers: HTTPHeaders? { HeaderBuilder().json().build() }
    var queryItems: [URLQueryItem]? { nil }
    var body: Data? { request.toJSONData() }
}

// MARK: - User DELETE Endpoint
struct DeleteUserEndpoint: Endpoint {
    let userId: Int
    
    var baseURL: URL { JSONPlaceholderEndpointGroup.base }
    var path: String { "/users/\(userId)" }
    var method: HTTPMethod { .delete }
    var headers: HTTPHeaders? { HeaderBuilder().json().build() }
    var queryItems: [URLQueryItem]? { nil }
    var body: Data? { nil }
}
