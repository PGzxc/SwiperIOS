import SwiftUI

struct AlbumView: View {
    var body: some View {
        ZStack {
            Color.white
            Text("图集")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.black)
        }
    }
}

#Preview {
    AlbumView()
}