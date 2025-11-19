//
//  MultipartFormData.swift
//  Demo1
//
//  Created by Vu Dang on 18/11/25.
//

import Foundation

struct MultipartFormData {
    let boundary = "Boundary-\(UUID().uuidString)"
    private var bodies: Data = Data()

    mutating func addField(name: String, value: String) {
        bodies.appendString("--\(boundary)\r\n")
        bodies.appendString("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n")
        bodies.appendString("\(value)\r\n")
    }

    mutating func addFile(name: String, filename: String, mimeType: String, data: Data) {
        bodies.appendString("--\(boundary)\r\n")
        bodies.appendString("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(filename)\"\r\n")
        bodies.appendString("Content-Type: \(mimeType)\r\n\r\n")
        bodies.append(data)
        bodies.appendString("\r\n")
    }

    mutating func finalize() {
        bodies.appendString("--\(boundary)--\r\n")
    }

    func build() -> (body: Data, contentType: String) {
        (bodies, "multipart/form-data; boundary=\(boundary)")
    }
}

private extension Data {
    mutating func appendString(_ string: String) {
        if let data = string.data(using: .utf8) { append(data) }
    }
}
