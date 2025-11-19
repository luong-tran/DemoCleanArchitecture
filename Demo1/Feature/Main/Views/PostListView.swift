//
//  PostListView.swift
//  Demo1
//
//  Created by Vu Dang on 18/11/25.
//

import SwiftUI

struct PostListView: View {
    let posts: [PostEntity]
    let onPut: (PostEntity) -> Void
    let onPatch: (PostEntity) -> Void
    let onDelete: (PostEntity) -> Void
    
    var body: some View {
        List {
            ForEach(posts.prefix(20)) { post in
                PostRowView(
                    post: post,
                    onPut: { onPut(post) },
                    onPatch: { onPatch(post) },
                    onDelete: { onDelete(post) }
                )
            }
        }
    }
}

// MARK: - Post Row Component
private struct PostRowView: View {
    let post: PostEntity
    let onPut: () -> Void
    let onPatch: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Text(post.title)
                    .font(.headline)
                    .lineLimit(2)
                
                Spacer()
                
                Button(action: onPut) {
                    Label("Put", systemImage: "square.and.pencil")
                        .labelStyle(.iconOnly)
                }
                .buttonStyle(.borderless)
                .foregroundColor(.orange)
                
                Button(action: onPatch) {
                    Label("Patch", systemImage: "pencil.line")
                        .labelStyle(.iconOnly)
                }
                .buttonStyle(.borderless)
                .foregroundColor(.purple)
                
                Button(action: onDelete) {
                    Label("Delete", systemImage: "trash")
                        .labelStyle(.iconOnly)
                }
                .buttonStyle(.borderless)
                .foregroundColor(.red)
            }
            
            Text(post.body)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(3)
            
            HStack {
                Label("ID: \(post.id)", systemImage: "number")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Label("User: \(post.userId)", systemImage: "person")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
