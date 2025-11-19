//
//  PostRealmObject.swift
//  Demo1
//
//  Created by Vu Dang on 18/11/25.
//

import Foundation
import RealmSwift

class PostRealmObject: BaseRealmObject, EntityConvertible {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var userId: Int
    @Persisted var title: String
    @Persisted var body: String
    
    convenience init(id: Int, userId: Int, title: String, body: String) {
        self.init()
        self.id = id
        self.userId = userId
        self.title = title
        self.body = body
        self.updatedAt = Date()
    }
}

// MARK: - Entity Conversion
extension PostRealmObject {
    func toEntity() -> PostEntity {
        PostEntity(
            id: id,
            userId: userId,
            title: title,
            body: body
        )
    }
}

extension PostEntity: RealmEntityConvertible {
    typealias RealmObjectType = PostRealmObject
    
    func toRealmObject() -> PostRealmObject {
        PostRealmObject(
            id: id,
            userId: userId,
            title: title,
            body: body
        )
    }
    
    static func fromRealmObject(_ realmObject: PostRealmObject) -> PostEntity {
        PostEntity(
            id: realmObject.id,
            userId: realmObject.userId,
            title: realmObject.title,
            body: realmObject.body
        )
    }
}
