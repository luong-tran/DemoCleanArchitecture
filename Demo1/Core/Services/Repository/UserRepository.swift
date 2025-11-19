//
//  UserRepository.swift
//  Demo1
//
//  Created by Vu Dang on 18/11/25.
//

import Foundation
import Combine
import RealmSwift

protocol UserRepositoryProtocol {
    func getUsers() -> AnyPublisher<[UserEntity], Error>
    func getUser(id: Int) -> AnyPublisher<UserEntity, Error>
    func createUser(_ request: CreateUserRequest) -> AnyPublisher<UserEntity, Error>
    func updateUser(id: Int, request: CreateUserRequest) -> AnyPublisher<UserEntity, Error>
    func patchUser(id: Int, request: UpdateUserRequest) -> AnyPublisher<UserEntity, Error>
    func deleteUser(id: Int) -> AnyPublisher<Void, Error>
}

final class UserRepository: UserRepositoryProtocol, BaseLocalStorageService {
    typealias EntityType = UserEntity
    typealias RealmObjectType = UserRealmObject
    
    private let networkClient: NetworkClientProtocol
    
    init(networkClient: NetworkClientProtocol = NetworkClient()) {
        self.networkClient = networkClient
    }
    
    // MARK: - Override saveToLocal with proper type conversion
    func saveToLocal(_ entities: [UserEntity]) async {
        do {
            let realmObjects = entities.map { $0.toRealmObject() }
            try await realmManager.add(realmObjects, update: .modified)
        } catch {
            print("❌ Failed to save users to local: \(error)")
        }
    }
    
    // MARK: - GET Operations
    func getUsers() -> AnyPublisher<[UserEntity], Error> {
        // Load from local first (immediate response)
        let localUsers = Just(getFromLocal())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
        // Then fetch from network and update local
        let networkUsers = networkClient.request(GetUsersEndpoint(), type: [User].self)
            .map { users in users.map { $0.toEntity() } }
            .handleEvents(receiveOutput: { [weak self] entities in
                Task {
                    await self?.saveToLocal(entities)
                }
            })
        
        // Merge: local first, then network updates
        return Publishers.Merge(localUsers, networkUsers)
            .eraseToAnyPublisher()
    }
    
    func getUser(id: Int) -> AnyPublisher<UserEntity, Error> {
        // Try local first
        if let localUser = getFromLocal(id: id) {
            let localPublisher = Just(localUser)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
            
            // Then fetch from network and update
            let networkPublisher = networkClient.request(GetUserEndpoint(userId: id), type: User.self)
                .map { $0.toEntity() }
                .handleEvents(receiveOutput: { [weak self] entity in
                    Task {
                        await self?.saveToLocal(entity)
                    }
                })
            
            return Publishers.Merge(localPublisher, networkPublisher)
                .eraseToAnyPublisher()
        }
        
        // If not in local, fetch from network
        return networkClient.request(GetUserEndpoint(userId: id), type: User.self)
            .map { [weak self] user in
                let entity = user.toEntity()
                Task {
                    await self?.saveToLocal(entity)
                }
                return entity
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - POST Operation
    func createUser(_ request: CreateUserRequest) -> AnyPublisher<UserEntity, Error> {
        networkClient.request(CreateUserEndpoint(request: request), type: User.self)
            .map { [weak self] user in
                let entity = user.toEntity()
                Task {
                    await self?.saveToLocal(entity)
                }
                return entity
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - PUT Operation
    func updateUser(id: Int, request: CreateUserRequest) -> AnyPublisher<UserEntity, Error> {
        networkClient.request(UpdateUserEndpoint(userId: id, request: request), type: User.self)
            .map { [weak self] user in
                let entity = user.toEntity()
                Task {
                    await self?.saveToLocal(entity)
                }
                return entity
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - PATCH Operation
    func patchUser(id: Int, request: UpdateUserRequest) -> AnyPublisher<UserEntity, Error> {
        networkClient.request(PatchUserEndpoint(userId: id, request: request), type: User.self)
            .map { [weak self] user in
                let entity = user.toEntity()
                Task {
                    await self?.saveToLocal(entity)
                }
                return entity
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - DELETE Operation
    func deleteUser(id: Int) -> AnyPublisher<Void, Error> {
        networkClient.request(DeleteUserEndpoint(userId: id), type: EmptyResponse.self)
            .handleEvents(receiveOutput: { [weak self] _ in
                Task {
                    await self?.deleteFromLocal(id: id)
                }
            })
            .map { _ in () }
            .eraseToAnyPublisher()
    }
}
