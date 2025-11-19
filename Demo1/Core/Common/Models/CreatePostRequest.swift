//
//  CreatePostRequest.swift
//  Demo1
//
//  Created by Vu Dang on 18/11/25.
//

import Foundation

struct CreatePostRequest: JSONBodyEncodable {
    let title: String
    let body: String
    let userId: Int
}
