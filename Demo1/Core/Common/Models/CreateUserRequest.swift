//
//  CreateUserRequest.swift
//  Demo1
//
//  Created by Vu Dang on 18/11/25.
//

import Foundation

struct CreateUserRequest: JSONBodyEncodable {
    let name: String
    let username: String
    let email: String
    let phone: String?
    let website: String?
}
