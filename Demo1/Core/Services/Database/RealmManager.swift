//
//  RealmManager.swift
//  Demo1
//
//  Created by Vu Dang on 18/11/25.
//

import Foundation
import RealmSwift

final class RealmManager {
    static let shared = RealmManager()
    
    private init() {}
    
    // Current schema version - increment when schema changes
    private let schemaVersion: UInt64 = 1
    
    func configure() {
        AppLogger.log("Configuring Realm", level: .info, category: .database)
        let config = Realm.Configuration(
            schemaVersion: schemaVersion,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 1 {
                    self.migrateToVersion1(migration: migration)
                }
            },
            objectTypes: [
                PostRealmObject.self,
                UserRealmObject.self,
            ]
        )
        
        Realm.Configuration.defaultConfiguration = config
    }
    
    // MARK: - Realm Instance Helper (Thread-safe)
    /// Get a new Realm instance - thread-safe, creates new instance each time
    func getRealm() throws -> Realm {
        do {
            return try Realm()
        } catch {
            AppLogger.log("Realm init failed", level: .error, category: .database, error: error)
            throw error
        }
    }
    
    // MARK: - Write Operations (Async)
    
    /// Add objects with update policy
    func add<T: Object>(_ objects: [T], update: Realm.UpdatePolicy = .modified) async throws {
        AppLogger.log("Realm add \(objects.count) objects", level: .debug, category: .database, metadata: ["type": "\(T.self)"])
        let realm = try getRealm()
        try realm.write {
            realm.add(objects, update: update)
        }
    }
    
    /// Add single object
    func add<T: Object>(_ object: T, update: Realm.UpdatePolicy = .modified) async throws {
        try await add([object], update: update)
    }
    
    /// Delete object
    func delete<T: Object>(_ object: T) async throws {
        let realm = try getRealm()
        try realm.write {
            realm.delete(object)
        }
    }
    
    /// Delete objects
    func delete<T: Object>(_ objects: [T]) async throws {
        let realm = try getRealm()
        try realm.write {
            realm.delete(objects)
        }
    }
    
    // MARK: - Read Operations (Synchronous - Thread-safe)
    
    /// Get all objects of type
    func getObjects<T: Object>(_ type: T.Type) throws -> Results<T> {
        let realm = try getRealm()
        return realm.objects(type)
    }
    
    /// Get objects sorted by key path
    func getObjects<T: Object>(_ type: T.Type, sortedBy keyPath: String, ascending: Bool = true) throws -> Results<T> {
        let realm = try getRealm()
        return realm.objects(type).sorted(byKeyPath: keyPath, ascending: ascending)
    }
    
    /// Get object by primary key
    func getObject<T: Object>(_ type: T.Type, primaryKey: Any) throws -> T? {
        let realm = try getRealm()
        return realm.object(ofType: type, forPrimaryKey: primaryKey)
    }
    
    /// Check if object exists
    func exists<T: Object>(_ type: T.Type, primaryKey: Any) -> Bool {
        do {
            return try getObject(type, primaryKey: primaryKey) != nil
        } catch {
            return false
        }
    }
    
    // MARK: - Migration Methods
    private func migrateToVersion1(migration: Migration) {
        migration.enumerateObjects(ofType: PostRealmObject.className()) { oldObject, newObject in
            // Migration logic if needed
        }
        
        migration.enumerateObjects(ofType: UserRealmObject.className()) { oldObject, newObject in
            // Migration logic if needed
        }
    }
}
