//
//  TagPickerView.swift
//  commit
//
//  Created by Eleonora Persico on 10/11/25.
//

//
//  TagPickerView.swift
//  commit
//
//  Created by Eleonora Persico on 10/11/25.
//

import SwiftUI
import SwiftData

struct TagPickerView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @Binding var selectedTag: Tag?
    
    @Query(sort: \Tag.title) private var allTags: [Tag]
    
    @State private var showingAddTag = false
    @State private var newTagName = ""
    
    var body: some View {
        NavigationStack {
            List {
                Section("Tags") {
                    ForEach(allTags) { tag in
                        Button {
                            selectedTag = tag
                            dismiss()
                        } label: {
                            HStack {
                                Text(tag.title)
                                Spacer()
                                if selectedTag?.id == tag.id {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Select Tag")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddTag = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .alert("Add Custom Tag", isPresented: $showingAddTag) {
                TextField("Enter tag name", text: $newTagName)
                Button("Cancel", role: .cancel) {
                    newTagName = ""
                }
                Button("Add") {
                    addTag()
                }
            } message: {
                Text("Create a new tag for your wins")
            }
        }
        .presentationDetents([.medium])
    }
    
    private func addTag() {
        let trimmed = newTagName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        let finalName = trimmed.hasPrefix("#") ? trimmed : "#\(trimmed)"
        
        // prevent duplicates
        if let existing = allTags.first(where: { $0.title == finalName }) {
            selectedTag = existing
            dismiss()
            return
        }
        
        let newTag = Tag(title: finalName)
        modelContext.insert(newTag)
        
        selectedTag = newTag
        newTagName = ""
        dismiss()
    }
}

/*

#Preview {
    @Previewable @State var selectedTag = ""
    TagPickerView(selectedTag: $selectedTag)
}
*/
