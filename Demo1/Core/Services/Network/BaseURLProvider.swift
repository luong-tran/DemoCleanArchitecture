//
//  BaseURLProvider.swift
//  Demo1
//
//  Created by Vu Dang on 18/11/25.
//

import Foundation

protocol BaseURLProvider {
    var baseURL: URL { get }
}

struct DefaultBaseURLProvider: BaseURLProvider {
    let baseURL = URL(string: "https://api.example.com")!
}
