import SwiftUI

struct MeView: View {
    var body: some View {
        ZStack {
            Color.white
            Text("我")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.black)
        }
    }
}

#Preview {
    MeView()
}