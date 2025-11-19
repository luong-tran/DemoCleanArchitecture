//
//  User.swift
//  Demo1
//
//  Created by Vu Dang on 18/11/25.
//

import Foundation

// API Response DTO
struct User: Codable {
    let id: Int
    let name: String
    let username: String
    let email: String
    let phone: String?
    let website: String?
    let address: Address?
    let company: Company?
}

struct Address: Codable {
    let street: String
    let suite: String?
    let city: String
    let zipcode: String
    let geo: Geo?
}

struct Geo: Codable {
    let lat: String
    let lng: String
}

struct Company: Codable {
    let name: String
    let catchPhrase: String?
    let bs: String?
}

// Extension to convert DTO -> Entity
extension User {
    func toEntity() -> UserEntity {
        UserEntity(
            id: id,
            name: name,
            username: username,
            email: email,
            phone: phone,
            website: website
        )
    }
}
