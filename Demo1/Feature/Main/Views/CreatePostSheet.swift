//
//  CreatePostSheet.swift
//  Demo1
//
//  Created by Vu Dang on 18/11/25.
//

import SwiftUI

struct CreatePostSheet: View {
    @ObservedObject var viewModel: PostViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var content = ""
    @State private var userId = 1
    
    var body: some View {
        NavigationView {
            Form {
                Section("POST - Create New Post") {
                    TextField("Title", text: $title)
                    TextEditor(text: $content)
                        .frame(height: 100)
                    Stepper("User ID: \(userId)", value: $userId, in: 1...10)
                }
                
                Section {
                    Text("POST method creates a new resource. The server will assign a new ID.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Create Post")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        viewModel.createPost(title: title, body: content, userId: userId)
                        dismiss()
                    }
                    .disabled(title.isEmpty || content.isEmpty)
                }
            }
        }
    }
}
