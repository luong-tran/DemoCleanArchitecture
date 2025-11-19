//
//  Post.swift
//  Demo1
//
//  Created by Vu Dang on 18/11/25.
//

import Foundation

// API Response DTO
struct Post: Codable {
    let id: Int
    let userId: Int
    let title: String
    let body: String
}

// Extension to convert DTO -> Entity
extension Post {
    func toEntity() -> PostEntity {
        PostEntity(
            id: id,
            userId: userId,
            title: title,
            body: body
        )
    }
}
