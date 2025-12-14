import SwiftUI

struct MessageView: View {
    var body: some View {
        ZStack {
            Color.white
            Text("消息")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.black)
        }
    }
}

#Preview {
    MessageView()
}