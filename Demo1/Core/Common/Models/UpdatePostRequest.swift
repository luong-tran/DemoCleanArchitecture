//
//  UpdatePostRequest.swift
//  Demo1
//
//  Created by Vu Dang on 18/11/25.
//

import Foundation

struct UpdatePostRequest: JSONBodyEncodable {
    let title: String?
    let body: String?
}
