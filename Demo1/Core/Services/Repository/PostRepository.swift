//
//  PostRepository.swift
//  Demo1
//
//  Created by Vu Dang on 18/11/25.
//

import Foundation
import RealmSwift

protocol PostRepositoryProtocol {
    func getPosts() async throws -> [PostEntity]
    func getPost(id: Int) async throws -> PostEntity
    func createPost(_ request: CreatePostRequest) async throws -> PostEntity
    func updatePost(id: Int, request: CreatePostRequest) async throws -> PostEntity
    func patchPost(id: Int, request: UpdatePostRequest) async throws -> PostEntity
    func deletePost(id: Int) async throws
}

final class PostRepository: PostRepositoryProtocol, BaseLocalStorageService {
    typealias EntityType = PostEntity
    typealias RealmObjectType = PostRealmObject
    
    private let networkClient: NetworkClientProtocol
    
    init(networkClient: NetworkClientProtocol = NetworkClient()) {
        self.networkClient = networkClient
    }
    
    // MARK: - Override saveToLocal with proper type conversion
    func saveToLocal(_ entities: [PostEntity]) async {
        do {
            let realmObjects = entities.map { $0.toRealmObject() }
            try await realmManager.add(realmObjects, update: .modified)
            AppLogger.repository("Saved posts to Realm", metadata: ["count": entities.count])
        } catch {
            AppLogger.repository("Failed saving posts", level: .error, error: error)
        }
    }
    
    // MARK: - GET Operations
    func getPosts() async throws -> [PostEntity] {
        // Load from local first (immediate response)
        let localPosts = getFromLocal()
        AppLogger.repository("Return cached posts", metadata: ["count": localPosts.count, "entity": "Post"])

        // Fetch from network in background and update local
        Task {
            do {
                let posts = try await networkClient.request(GetPostsEndpoint(), type: [Post].self)
                let entities = posts.map { $0.toEntity() }
                await saveToLocal(entities)
                AppLogger.repository("Synced posts from API", metadata: ["count": entities.count])
            } catch {
                AppLogger.repository("Failed to sync posts", level: .warning, error: error)
            }
        }
        
        return localPosts
    }
    
    func getPost(id: Int) async throws -> PostEntity {
        // Try local first
        if let localPost = getFromLocal(id: id) {
            AppLogger.repository("Use cached post", metadata: ["id": id])

            // Fetch from network in background
            Task {
                do {
                    let post = try await networkClient.request(GetPostEndpoint(postId: id), type: Post.self)
                    await saveToLocal(post.toEntity())
                } catch {
                    print("❌ Failed to sync post from network: \(error)")
                }
            }
            return localPost
        }
        AppLogger.repository("Fetch post from API", metadata: ["id": id])

        // If not in local, fetch from network
        let post = try await networkClient.request(GetPostEndpoint(postId: id), type: Post.self)
        let entity = post.toEntity()
        await saveToLocal(entity)
        return entity
    }
    
    // MARK: - POST Operation
    func createPost(_ request: CreatePostRequest) async throws -> PostEntity {
        let post = try await networkClient.request(CreatePostEndpoint(request: request), type: Post.self)
        let entity = post.toEntity()
        await saveToLocal(entity)
        return entity
    }
    
    // MARK: - PUT Operation
    func updatePost(id: Int, request: CreatePostRequest) async throws -> PostEntity {
        let post = try await networkClient.request(UpdatePostEndpoint(postId: id, request: request), type: Post.self)
        let entity = post.toEntity()
        await saveToLocal(entity)
        return entity
    }
    
    // MARK: - PATCH Operation
    func patchPost(id: Int, request: UpdatePostRequest) async throws -> PostEntity {
        let post = try await networkClient.request(PatchPostEndpoint(postId: id, request: request), type: Post.self)
        let entity = post.toEntity()
        await saveToLocal(entity)
        return entity
    }
    
    // MARK: - DELETE Operation
    func deletePost(id: Int) async throws {
        _ = try await networkClient.request(DeletePostEndpoint(postId: id), type: EmptyResponse.self)
        await deleteFromLocal(id: id)
    }
}
