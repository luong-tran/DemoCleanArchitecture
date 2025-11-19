//
//  BaseLocalStorageService.swift
//  Demo1
//
//  Created by Vu Dang on 18/11/25.
//

import Foundation
import RealmSwift

/// Generic base service for local storage operations
/// Reduces code duplication across repositories
protocol BaseLocalStorageService {
    associatedtype EntityType
    associatedtype RealmObjectType: Object & EntityConvertible where RealmObjectType.EntityType == EntityType
    
    var realmManager: RealmManager { get }
    var sortKeyPath: String { get }
    var sortAscending: Bool { get }
}

extension BaseLocalStorageService {
    var realmManager: RealmManager { RealmManager.shared }
    var sortKeyPath: String { "id" }
    var sortAscending: Bool { false }
    
    // MARK: - Save Operations
    func saveToLocal(_ entities: [EntityType]) async {
        // Each repository will implement this with proper type conversion
        // This is a template - override in concrete implementations if needed
    }
    
    func saveToLocal(_ entity: EntityType) async {
        await saveToLocal([entity])
    }
    
    // MARK: - Read Operations
    func getFromLocal() -> [EntityType] {
        do {
            let realmObjects = try realmManager.getObjects(RealmObjectType.self, sortedBy: sortKeyPath, ascending: sortAscending)
            return Array(realmObjects.map { $0.toEntity() })
        } catch {
            print("❌ Failed to get \(String(describing: EntityType.self)) from local: \(error)")
            return []
        }
    }
    
    func getFromLocal(id: Int) -> EntityType? {
        do {
            guard let realmObject = try realmManager.getObject(RealmObjectType.self, primaryKey: id) else {
                return nil
            }
            return realmObject.toEntity()
        } catch {
            print("❌ Failed to get \(String(describing: EntityType.self)) from local: \(error)")
            return nil
        }
    }
    
    // MARK: - Delete Operations
    func deleteFromLocal(id: Int) async {
        do {
            guard let realmObject = try realmManager.getObject(RealmObjectType.self, primaryKey: id) else {
                return
            }
            try await realmManager.delete(realmObject)
        } catch {
            print("❌ Failed to delete \(String(describing: EntityType.self)) from local: \(error)")
        }
    }
}
