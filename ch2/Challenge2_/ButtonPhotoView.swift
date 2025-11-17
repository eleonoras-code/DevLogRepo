//
//  ButtonPhotoView.swift
//  commit
//
//  Created by Eleonora Persico on 10/11/25.
//

import SwiftUI
import PhotosUI
import SwiftData

struct ButtonPhotoView: View {
    @Binding var selectedImage: UIImage?
    @State private var selectedItem: PhotosPickerItem?
    
    
    var body: some View {
        VStack {
            PhotosPicker(selection: $selectedItem, matching: .images) {
                ZStack {
                    Circle()
                        .fill(Color.accent)
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: "photo")
                        .font(.system(size: 24))
                        .foregroundColor(.black)
                    
                }
            }.onChange(of: selectedItem) { oldValue, newValue in
                Task {
                    if let data = try? await newValue?.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        selectedImage = image
                    }
                }
            }
        }

    }
}

#Preview {
    ButtonPhotoView(selectedImage: .constant(nil))
        .preferredColorScheme(.dark)
}
