//
//  EndpointGroup.swift
//  Demo1
//
//  Created by Vu Dang on 18/11/25.
//

import Foundation

protocol EndpointGroup {
    associatedtype T: Endpoint
    static var base: URL { get }
}
