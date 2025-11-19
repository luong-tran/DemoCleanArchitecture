//
//  UpdatePostSheet.swift
//  Demo1
//
//  Created by Vu Dang on 18/11/25.
//

import SwiftUI

struct UpdatePostSheet: View {
    @ObservedObject var viewModel: PostViewModel
    let post: PostEntity
    @Environment(\.dismiss) var dismiss
    
    // Initialize State directly
    @State private var title: String = ""
    @State private var content: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section("PUT - Replace Entire Post") {
                    TextField("Title", text: $title)
                    TextEditor(text: $content)
                        .frame(height: 100)
                }
                
                Section {
                    Text("PUT method replaces the entire resource. All fields must be provided.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Update Post")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Update") {
                        viewModel.updatePost(
                            id: post.id,
                            title: title,
                            body: content,
                            userId: post.userId
                        )
                        dismiss()
                    }
                    .disabled(title.isEmpty || content.isEmpty)
                }
            }
            .onAppear {
                // Set values when view appears
                title = post.title
                content = post.body
            }
        }
    }
}
