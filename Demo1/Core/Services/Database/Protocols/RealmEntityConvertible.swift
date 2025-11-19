//
//  RealmEntityConvertible.swift
//  Demo1
//
//  Created by Vu Dang on 18/11/25.
//

import Foundation
import RealmSwift

// Protocol for entities that can be converted to/from Realm objects
protocol RealmEntityConvertible {
    associatedtype RealmObjectType: Object
    
    func toRealmObject() -> RealmObjectType
    static func fromRealmObject(_ realmObject: RealmObjectType) -> Self
}

// Protocol for Realm objects that can be converted to entities
protocol EntityConvertible {
    associatedtype EntityType
    
    func toEntity() -> EntityType
}
