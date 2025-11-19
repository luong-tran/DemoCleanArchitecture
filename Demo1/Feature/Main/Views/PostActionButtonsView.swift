//
//  PostActionButtonsView.swift
//  Demo1
//
//  Created by Vu Dang on 18/11/25.
//

import SwiftUI

struct PostActionButtonsView: View {
    @ObservedObject var viewModel: PostViewModel
    let posts: [PostEntity]
    let onPutTapped: (PostEntity) -> Void
    let onPatchTapped: (PostEntity) -> Void
    let onCreateTapped: () -> Void
    
    private var latestPost: PostEntity? {
        posts.max(by: { $0.id < $1.id })
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                // GET All
                ActionButton(
                    title: "GET All",
                    icon: "arrow.down.circle.fill",
                    color: .blue
                ) {
                    viewModel.loadPosts()
                }
                
                // GET by ID
                ActionButton(
                    title: "GET by ID (1)",
                    icon: "magnifyingglass",
                    color: .blue
                ) {
                    viewModel.loadPost(id: 1)
                }
                
                // POST
                ActionButton(
                    title: "POST",
                    icon: "plus.circle.fill",
                    color: .green
                ) {
                    onCreateTapped()
                }
                
                // PUT (newest ID)
                ActionButton(
                    title: "PUT latest",
                    icon: "arrow.clockwise.circle.fill",
                    color: .orange,
                    isDisabled: latestPost == nil
                ) {
                    if let target = latestPost {
                        onPutTapped(target)
                    }
                }
                
                // PATCH (newest ID)
                ActionButton(
                    title: "PATCH latest",
                    icon: "pencil.circle.fill",
                    color: .purple,
                    isDisabled: latestPost == nil
                ) {
                    if let target = latestPost {
                        onPatchTapped(target)
                    }
                }
                
                // DELETE newest
                ActionButton(
                    title: "DELETE latest",
                    icon: "trash.circle.fill",
                    color: .red,
                    isDisabled: latestPost == nil
                ) {
                    if let target = latestPost {
                        viewModel.deletePost(id: target.id)
                    }
                }
            }
            .padding()
        }
    }
}

// MARK: - Action Button Component
private struct ActionButton: View {
    let title: String
    let icon: String
    let color: Color
    var isDisabled: Bool = false
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.caption)
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(color.opacity(isDisabled ? 0.3 : 0.2))
            .foregroundColor(isDisabled ? .gray : color)
            .cornerRadius(8)
        }
        .disabled(isDisabled)
    }
}
