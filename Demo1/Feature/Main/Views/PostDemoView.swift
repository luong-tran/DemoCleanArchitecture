//
//  PostDemoView.swift
//  Demo1
//
//  Created by Vu Dang on 18/11/25.
//

import SwiftUI

private enum PostSheet: Identifiable {
    case create
    case update(PostEntity)
    case patch(PostEntity)
    
    var id: String {
        switch self {
        case .create: return "create"
        case .update(let post): return "update-\(post.id)"
        case .patch(let post): return "patch-\(post.id)"
        }
    }
}

struct PostDemoView: View {
    @StateObject private var viewModel = PostViewModel()
    @State private var activeSheet: PostSheet?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                PostStatusBarView(viewModel: viewModel)
                
                PostActionButtonsView(
                    viewModel: viewModel,
                    posts: viewModel.posts,
                    onPutTapped: { post in
                        activeSheet = .update(post)
                    },
                    onPatchTapped: { post in
                        activeSheet = .patch(post)
                    },
                    onCreateTapped: { activeSheet = .create }
                )
                
                PostListView(
                    posts: viewModel.posts,
                    onPut: { post in
                        activeSheet = .update(post)
                    },
                    onPatch: { post in
                        activeSheet = .patch(post)
                    },
                    onDelete: { post in
                        viewModel.deletePost(id: post.id)
                    }
                )
            }
            .navigationTitle("HTTP Methods Demo")
            .sheet(item: $activeSheet) { sheet in
                switch sheet {
                case .create:
                    CreatePostSheet(viewModel: viewModel)
                case .update(let post):
                    UpdatePostSheet(viewModel: viewModel, post: post)
                case .patch(let post):
                    PatchPostSheet(viewModel: viewModel, post: post)
                }
            }
            .onAppear {
                viewModel.loadPosts()
            }
        }
    }
}
