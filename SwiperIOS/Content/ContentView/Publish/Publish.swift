import SwiftUI

struct PublishView: View {
    var body: some View {
        ZStack {
            Color.white
            Text("发布")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.black)
        }
    }
}

#Preview {
    PublishView()
}