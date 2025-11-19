//
//  BodyEncodable.swift
//  Demo1
//
//  Created by Vu Dang on 18/11/25.
//

import Foundation

protocol JSONBodyEncodable: Encodable {}

extension JSONBodyEncodable {
    func toJSONData() -> Data? {
        try? JSONEncoder().encode(self)
    }
}

