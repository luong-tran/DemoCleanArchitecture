//
//  BaseRealmObject.swift
//  Demo1
//
//  Created by Vu Dang on 18/11/25.
//

import Foundation
import RealmSwift

// Base class for all Realm objects with common properties
class BaseRealmObject: Object {
    @Persisted var createdAt: Date = Date()
    @Persisted var updatedAt: Date = Date()
}
