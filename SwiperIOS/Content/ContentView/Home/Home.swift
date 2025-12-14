import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            Color.white
            Text("首页")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.black)
        }
    }
}

#Preview {
    HomeView()
}