//
//  PatchPostSheet.swift
//  Demo1
//
//  Created by Vu Dang on 18/11/25.
//

import SwiftUI

struct PatchPostSheet: View {
    @ObservedObject var viewModel: PostViewModel
    let post: PostEntity
    @Environment(\.dismiss) var dismiss
    
    // Initialize State directly, without using init
    @State private var title: String = ""
    @State private var content: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section("PATCH - Partial Update") {
                    TextField("Title (optional)", text: $title)
                    TextEditor(text: $content)
                        .frame(height: 100)
                }
                
                Section {
                    Text("PATCH method allows partial updates. Leave fields unchanged to keep original values.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Patch Post")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Patch") {
                        let finalTitle = title.isEmpty ? nil : title
                        let finalBody = content.isEmpty ? nil : content
                        viewModel.patchPost(id: post.id, title: finalTitle, body: finalBody)
                        dismiss()
                    }
                }
            }
            .onAppear {
                // Set values when view appears instead of in init
                title = post.title
                content = post.body
            }
        }
    }
}
