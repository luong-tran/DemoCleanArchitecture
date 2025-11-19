//
//  UserRealmObject.swift
//  Demo1
//
//  Created by Vu Dang on 18/11/25.
//

import Foundation
import RealmSwift

class UserRealmObject: BaseRealmObject, EntityConvertible {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var name: String
    @Persisted var username: String
    @Persisted var email: String
    @Persisted var phone: String?
    @Persisted var website: String?
    
    convenience init(id: Int, name: String, username: String, email: String, phone: String? = nil, website: String? = nil) {
        self.init()
        self.id = id
        self.name = name
        self.username = username
        self.email = email
        self.phone = phone
        self.website = website
        self.updatedAt = Date()
    }
}

// MARK: - Entity Conversion
extension UserRealmObject {
    func toEntity() -> UserEntity {
        UserEntity(
            id: id,
            name: name,
            username: username,
            email: email,
            phone: phone,
            website: website
        )
    }
}

extension UserEntity: RealmEntityConvertible {
    typealias RealmObjectType = UserRealmObject
    
    func toRealmObject() -> UserRealmObject {
        UserRealmObject(
            id: id,
            name: name,
            username: username,
            email: email,
            phone: phone,
            website: website
        )
    }
    
    static func fromRealmObject(_ realmObject: UserRealmObject) -> UserEntity {
        UserEntity(
            id: realmObject.id,
            name: realmObject.name,
            username: realmObject.username,
            email: realmObject.email,
            phone: realmObject.phone,
            website: realmObject.website
        )
    }
}
