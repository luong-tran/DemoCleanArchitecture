//
//  PostViewModel.swift
//  Demo1
//
//  Created by Vu Dang on 18/11/25.
//

import Foundation
import Combine

@MainActor
final class PostViewModel: BaseViewModel {
    // MARK: - Published Properties
    @Published var posts: [PostEntity] = []
    @Published var selectedPost: PostEntity?
    
    // MARK: - Dependencies
    private let repository: PostRepositoryProtocol
    
    // MARK: - Initialization
    init(repository: PostRepositoryProtocol = PostRepository()) {
        self.repository = repository
        super.init()
    }
    
    // MARK: - GET Methods
    func loadPosts() {
        executeAsync(
            operation: "GET: Loading all posts",
            task: { [weak self] in
                guard let self = self else { throw RepositoryError.repositoryDeallocated }
                return try await self.repository.getPosts()
            }
        ) { [weak self] posts in
            self?.posts = posts
            self?.setLastOperation("GET: Loaded \(posts.count) posts")
        }
    }
    
    func loadPost(id: Int) {
        executeAsync(
            operation: "GET: Loading post \(id)",
            task: { [weak self] in
                guard let self = self else { throw RepositoryError.repositoryDeallocated }
                return try await self.repository.getPost(id: id)
            }
        ) { [weak self] post in
            guard let self = self else { return }
            
            // Update selectedPost
            self.selectedPost = post
            
            // Update post in list if it already exists
            if let index = self.posts.firstIndex(where: { $0.id == post.id }) {
                self.posts[index] = post
            } else {
                // If not in list, add to the beginning
                self.posts.insert(post, at: 0)
            }
            
            self.setLastOperation("GET: Loaded post \(post.id)")
        }
    }
    
    // MARK: - POST Method
    func createPost(title: String, body: String, userId: Int = 1) {
        let request = CreatePostRequest(title: title, body: body, userId: userId)
        
        executeAsync(
            operation: "POST: Creating post",
            task: { [weak self] in
                guard let self = self else { throw RepositoryError.repositoryDeallocated }
                return try await self.repository.createPost(request)
            }
        ) { [weak self] post in
            self?.posts.insert(post, at: 0)
            self?.setLastOperation("POST: Created post with ID \(post.id)")
        }
    }
    
    // MARK: - PUT Method
    func updatePost(id: Int, title: String, body: String, userId: Int) {
        let request = CreatePostRequest(title: title, body: body, userId: userId)
        
        executeAsync(
            operation: "PUT: Updating post \(id)",
            task: { [weak self] in
                guard let self = self else { throw RepositoryError.repositoryDeallocated }
                return try await self.repository.updatePost(id: id, request: request)
            }
        ) { [weak self] updatedPost in
            if let index = self?.posts.firstIndex(where: { $0.id == updatedPost.id }) {
                self?.posts[index] = updatedPost
            }
            self?.setLastOperation("PUT: Updated post \(updatedPost.id)")
        }
    }
    
    // MARK: - PATCH Method
    func patchPost(id: Int, title: String? = nil, body: String? = nil) {
        let request = UpdatePostRequest(title: title, body: body)
        
        executeAsync(
            operation: "PATCH: Patching post \(id)",
            task: { [weak self] in
                guard let self = self else { throw RepositoryError.repositoryDeallocated }
                return try await self.repository.patchPost(id: id, request: request)
            }
        ) { [weak self] patchedPost in
            if let index = self?.posts.firstIndex(where: { $0.id == patchedPost.id }) {
                self?.posts[index] = patchedPost
            }
            self?.setLastOperation("PATCH: Patched post \(patchedPost.id)")
        }
    }
    
    // MARK: - DELETE Method
    func deletePost(id: Int) {
        executeAsync(
            operation: "DELETE: Deleting post \(id)",
            task: { [weak self] in
                guard let self = self else { throw RepositoryError.repositoryDeallocated }
                try await self.repository.deletePost(id: id)
            }
        ) { [weak self] _ in
            self?.posts.removeAll { $0.id == id }
            self?.setLastOperation("DELETE: Deleted post \(id)")
        }
    }
}

// MARK: - Error Types
enum RepositoryError: Error {
    case repositoryDeallocated
    case invalidData
    
    var localizedDescription: String {
        switch self {
        case .repositoryDeallocated:
            return "Repository has been deallocated"
        case .invalidData:
            return "Invalid data received"
        }
    }
}
