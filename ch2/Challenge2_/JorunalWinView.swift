import SwiftUI
import SwiftData

struct JournalWinView: View {
    let win: Win
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(win.date.formatted(date: .long, time: .omitted))
                .font(.caption)
                .fontWeight(.thin)
                .foregroundStyle(.white)
            
            Text(win.title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundStyle(.white)
            
            Text(win.text)
                .font(.body)
                .foregroundStyle(.white)
                .fixedSize(horizontal: false, vertical: true)
            
            if let data = win.imageData,
               let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(maxHeight: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .clipped()
            }

            
            if let tag = win.tag {
                Text(tag.title)
                    .font(.custom("GeistMono-Bold", size: 15))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(8)
                    .foregroundStyle(Color.accentColor)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color(red: 0.19, green: 0.19, blue: 0.19))
        )
        .padding(.horizontal)
    }
}

/*
#Preview {
    JournalWinView(win: Win(
        title: "My First Win",
        text: "Today was amazing! I finally completed that project I've been working on for weeks.",
        date: .now,
        tag: Tag?
    ))
    .preferredColorScheme(.dark)
}
*/
