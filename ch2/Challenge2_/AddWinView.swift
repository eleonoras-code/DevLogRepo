//
//  AddWinView.swift
//  commit
//
//  Created by Eleonora Persico on 10/11/25.
//

//
//  AddWinView.swift
//  commit
//
//  Created by Eleonora Persico on 10/11/25.
//

import SwiftUI
import SwiftData

struct AddWinView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Bindable var win: Win // allows the database to be up to date if something in the ui changes. if the user changes the title in the textfield then it changes in the database as well! 
    
    @State private var selectedImage: UIImage?
    @State private var showingTagPicker = false
    @State private var isNewWin: Bool = false   // tracks whether this win was just created
    
    var body: some View {
        VStack(spacing: 0) {
            Form {
                
            
                DatePicker("Date", selection: $win.date, displayedComponents: .date)
                
        
                TextField("Title", text: $win.title)
                    .font(.headline)
                
        
                Button {
                    showingTagPicker = true
                } label: {
                    HStack {
                        Text("Tag")
                            .foregroundStyle(.primary)
                        Spacer()
                        Text(win.tag?.title ?? "Select a tag")
                            .foregroundColor(win.tag == nil ? .gray : .primary)
                    }
                }
                
              
                Section {
                    ZStack(alignment: .topLeading) {
                        if win.text.isEmpty {
                            Text("Write your win...")
                                .foregroundColor(.gray)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 12)
                        }
                        
                        TextEditor(text: $win.text)
                            .frame(minHeight: 200)
                            .padding(4)
                    }
                }
                

                HStack {
                    ButtonPhotoView(selectedImage: $selectedImage)
                    Spacer()
                }
        
                if let image = selectedImage {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.secondarySystemBackground))
                            .shadow(radius: 2)
                        
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .frame(maxWidth: .infinity)
                    .aspectRatio(1.5, contentMode: .fit)
                    .padding(.vertical, 8)
                }
            }
        }
        
 
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("", systemImage: "checkmark") {
                    saveWin()
                    dismiss()
                }
                .foregroundColor(win.title.trimmed.isEmpty ? .gray : .accentColor)
                .disabled(win.title.trimmed.isEmpty)
            }
        }

        .sheet(isPresented: $showingTagPicker) {
            TagPickerView(selectedTag: $win.tag)
        }

        .onAppear {
            isNewWin = win.title.isEmpty
            
            if selectedImage == nil,
               let data = win.imageData,
               let img = UIImage(data: data) {
                selectedImage = img
            }
        }
    }
 
    private func saveWin() {
        
        if isNewWin {
               modelContext.insert(win)
           }
        
        // save image
        if let image = selectedImage,
           let imageData = image.jpegData(compressionQuality: 0.8) {
            win.imageData = imageData
        }
    }
}

fileprivate extension String {
    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

#Preview {
    let preview: some View = {
        let schema = Schema([Win.self, Tag.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: schema, configurations: [config])
        let context = container.mainContext
        
        let previewWin = Win(
            title: "Preview Win",
            text: "This is a sample win entry.",
            date: .now,
            tag: nil
        )
        
        context.insert(previewWin)
        
        return NavigationStack {
            AddWinView(win: previewWin)
                .modelContainer(container)
        }
        .preferredColorScheme(.dark)
    }()
    
    return preview
}
