//
//  AppLogger.swift
//  Demo1
//
//  Created by Vu Dang on 19/11/25.
//

import Foundation
import os.log

enum LogLevel {
    case debug, info, warning, error
    
    var icon: String {
        switch self {
        case .debug:   return "🔍"
        case .info:    return "ℹ️"
        case .warning: return "⚠️"
        case .error:   return "❌"
        }
    }
    
    var osType: OSLogType {
        switch self {
        case .debug:   return .debug
        case .info:    return .info
        case .warning: return .default
        case .error:   return .error
        }
    }
}

enum LogCategory: String, CaseIterable {
    case system
    case network
    case repository
    case database
    case viewModel
    case ui
    
    var emoji: String {
        switch self {
        case .system:     return "🚀"
        case .network:    return "🌐"
        case .repository: return "📦"
        case .database:   return "💾"
        case .viewModel:  return "🧠"
        case .ui:         return "🖥"
        }
    }
    
    fileprivate var osLog: OSLog {
        OSLog(subsystem: AppLogger.subsystem, category: rawValue.uppercased())
    }
}

struct AppLogger {
    static let subsystem = Bundle.main.bundleIdentifier ?? "Demo1"
    private static let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "HH:mm:ss.SSS"
        return df
    }()
    
    static func log(
        _ message: String,
        level: LogLevel = .debug,
        category: LogCategory = .system,
        error: Error? = nil,
        metadata: [String: Any] = [:],
        file: String = #fileID,
        function: String = #function,
        line: Int = #line
    ) {
        let timestamp = dateFormatter.string(from: Date())
        let metaString = metadata
            .map { "\($0.key)=\($0.value)" }
            .joined(separator: " • ")
        var composed = "\(timestamp) \(level.icon)\(category.emoji) [\(category.rawValue.uppercased())] \(message)"
        
        if !metaString.isEmpty {
            composed.append(" | \(metaString)")
        }
        
        if let error {
            composed.append(" | error: \(error.localizedDescription)")
        }
        
        composed.append(" — \(file) ▶︎ \(function):\(line)")
        
        #if DEBUG
        print(composed)
        #endif
        
        os_log("%{public}@", log: category.osLog, type: level.osType, composed)
    }
    
    // Convenience shortcuts
    static func network(_ message: String, level: LogLevel = .info, metadata: [String: Any] = [:], error: Error? = nil, file: String = #fileID, function: String = #function, line: Int = #line) {
        log(message, level: level, category: .network, error: error, metadata: metadata, file: file, function: function, line: line)
    }
    
    static func repository(_ message: String, level: LogLevel = .info, metadata: [String: Any] = [:], error: Error? = nil, file: String = #fileID, function: String = #function, line: Int = #line) {
        log(message, level: level, category: .repository, error: error, metadata: metadata, file: file, function: function, line: line)
    }
    
    static func viewModel(_ message: String, level: LogLevel = .debug, metadata: [String: Any] = [:], error: Error? = nil, file: String = #fileID, function: String = #function, line: Int = #line) {
        log(message, level: level, category: .viewModel, error: error, metadata: metadata, file: file, function: function, line: line)
    }
}
