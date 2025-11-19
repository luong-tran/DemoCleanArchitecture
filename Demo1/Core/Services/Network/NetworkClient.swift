//
//  NetworkClient.swift
//  Demo1
//
//  Created by Vu Dang on 18/11/25.
//

import Foundation
import Combine

protocol NetworkClientProtocol {
    func request<T: Decodable>(_ endpoint: Endpoint, type: T.Type) -> AnyPublisher<T, Error>
    func request<T: Decodable>(_ endpoint: Endpoint, type: T.Type) async throws -> T
}

final class NetworkClient: NetworkClientProtocol {
    private let session: URLSession
    
    init(session: URLSession? = nil) {
        // Configure URLSession with timeout
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30.0  // 30 seconds
        configuration.timeoutIntervalForResource = 60.0 // 60 seconds
        configuration.waitsForConnectivity = true
        
        self.session = session ?? URLSession(configuration: configuration)
    }
    
    // MARK: - Combine version
    func request<T: Decodable>(_ endpoint: Endpoint, type: T.Type) -> AnyPublisher<T, Error> {
        guard let req = endpoint.urlRequest else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        let requestId = UUID().uuidString
        let start = Date()
        AppLogger.network("➡️ \(req.httpMethod ?? "") \(req.url?.absoluteString ?? "")",
                          metadata: ["requestId": requestId])
        
        return session.dataTaskPublisher(for: req)
            .handleEvents(receiveOutput: { output in
                let elapsed = String(format: "%.2fms", Date().timeIntervalSince(start) * 1000)
                AppLogger.network("✅ \(req.url?.path ?? "")",
                                  metadata: ["requestId": requestId,
                                             "status": (output.response as? HTTPURLResponse)?.statusCode ?? 0,
                                             "elapsed": elapsed,
                                             "bytes": output.data.count])
            }, receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    AppLogger.network("❌ \(req.url?.path ?? "")",
                                      level: .error,
                                      metadata: ["requestId": requestId],
                                      error: error)
                }
            })
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    // MARK: - async/await version
    func request<T: Decodable>(_ endpoint: Endpoint, type: T.Type) async throws -> T {
        guard let req = endpoint.urlRequest else {
            throw URLError(.badURL)
        }
        
        let requestId = UUID().uuidString
        let start = Date()
        AppLogger.network("➡️ \(req.httpMethod ?? "") \(req.url?.absoluteString ?? "")",
                          metadata: ["requestId": requestId])
        
        do {
            let (data, response) = try await session.data(for: req)
            let elapsed = String(format: "%.2fms", Date().timeIntervalSince(start) * 1000)
            AppLogger.network("✅ \(req.url?.path ?? "")",
                              metadata: ["requestId": requestId,
                                         "status": (response as? HTTPURLResponse)?.statusCode ?? 0,
                                         "elapsed": elapsed,
                                         "bytes": data.count])
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            AppLogger.network("❌ \(req.url?.path ?? "")",
                              level: .error,
                              metadata: ["requestId": requestId],
                              error: error)
            throw error
        }
    }
}
