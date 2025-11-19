//
//  BaseViewModel.swift
//  Demo1
//
//  Created by Vu Dang on 10/11/25.
//

import Foundation
import Combine

class BaseViewModel: ObservableObject {
    // MARK: - Published properties
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var lastOperation: String = ""
    
    // MARK: - Combine
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - State Management
    func setLoading(_ loading: Bool) {
        DispatchQueue.main.async {
            self.isLoading = loading
        }
    }
    
    func setError(_ error: Error?) {
        DispatchQueue.main.async {
            self.errorMessage = error?.localizedDescription
            if error != nil {
                self.isLoading = false
            }
        }
    }
    
    func setLastOperation(_ message: String) {
        DispatchQueue.main.async {
            self.lastOperation = message
        }
    }
    
    // MARK: - Error Handling
    func handleError(_ error: Error, operation: String = "") {
        AppLogger.viewModel("Error \(operation)", level: .error, error: error)
        DispatchQueue.main.async {
            let errorMessage: String
            if let urlError = error as? URLError {
                switch urlError.code {
                case .timedOut:
                    errorMessage = "Request timed out. Please check your connection."
                case .notConnectedToInternet:
                    errorMessage = "No internet connection."
                case .networkConnectionLost:
                    errorMessage = "Network connection lost."
                default:
                    errorMessage = error.localizedDescription
                }
            } else {
                errorMessage = error.localizedDescription
            }
            
            self.errorMessage = errorMessage
            self.isLoading = false
            if !operation.isEmpty {
                self.lastOperation = "\(operation) failed: \(errorMessage)"
            }
        }
    }
    
    // MARK: - Combine Helpers
    func execute<T>(
        operation: String,
        publisher: AnyPublisher<T, Error>,
        onSuccess: @escaping (T) -> Void,
        retries: Int = 0 // Add retry option
    ) {
        AppLogger.viewModel("Start \(operation)")
        setLoading(true)
        setLastOperation("\(operation)...")
        
        var publisherWithRetry = publisher
        
        // Add retry if needed
        if retries > 0 {
            publisherWithRetry = publisher
                .retry(retries)
                .eraseToAnyPublisher()
        }
        
        publisherWithRetry
            .subscribe(on: DispatchQueue.global(qos: .userInitiated)) // Chạy trên background thread
            .receive(on: DispatchQueue.main) // Receive results on main thread
            .sink { [weak self] completion in
                self?.setLoading(false)
                if case .failure(let error) = completion {
                    AppLogger.viewModel("Failure \(operation)", level: .error, error: error)
                    self?.handleError(error, operation: operation)
                } else {
                    AppLogger.viewModel("Finished \(operation)")
                }
            } receiveValue: { [weak self] value in
                onSuccess(value)
                self?.setLastOperation("\(operation) completed")
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Async/Await Helpers
    @MainActor
    func executeAsync<T>(
        operation: String,
        task: @escaping () async throws -> T,
        onSuccess: @escaping (T) -> Void
    ) {
        setLoading(true)
        setLastOperation("\(operation)...")
        
        Task {
            do {
                let result = try await task()
                await MainActor.run {
                    onSuccess(result)
                    setLastOperation("\(operation) completed")
                    setLoading(false)
                }
            } catch {
                handleError(error, operation: operation)
            }
        }
    }
    
    // MARK: - Reset
    func resetState() {
        errorMessage = nil
        isLoading = false
        lastOperation = ""
    }
}
