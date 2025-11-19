//
//  AuthorizedEndpoint.swift
//  Demo1
//
//  Created by Vu Dang on 18/11/25.
//

import Foundation

protocol AuthorizedEndpoint: Endpoint {}

extension AuthorizedEndpoint {
    var headers: HTTPHeaders? {
        var builder = HeaderBuilder().json()
//        builder = builder.bearer(AuthService.shared.token)
        return builder.build()
    }
}
