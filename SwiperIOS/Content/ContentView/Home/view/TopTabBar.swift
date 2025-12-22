import SwiftUI

struct TopTabBar: View {
    @Binding var selected: HomeTab

    var body: some View {
        ZStack {
            // center tabs
            HStack(spacing: 15) {
                tabLabel("同城", .city)
                Text("|")
                    .foregroundColor(Color.white.opacity(0.3))
                    .font(.system(size: 14))
                tabLabel("关注", .focus)
                Text("|")
                    .foregroundColor(Color.white.opacity(0.3))
                    .font(.system(size: 14))
                tabLabel("推荐", .recommend)
            }
            .frame(maxWidth: .infinity)

            // Left Search, Right Plus
            HStack {
                Button(action: { /* search */ }) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                }
                Spacer()
                Button(action: { /* publish */ }) {
                    Image(systemName: "plus")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 16)
        }
        .foregroundColor(.white)
        .font(.system(size: 17, weight: .bold))
        .padding(.vertical, 8)
        .background(Color.clear)
    }

    @ViewBuilder
    private func tabLabel(_ title: String, _ tab: HomeTab) -> some View {
        Text(title)
            .font(.system(size: selected == tab ? 18 : 17, weight: selected == tab ? .bold : .medium))
            .foregroundColor(selected == tab ? .white : Color.white.opacity(0.6))
            .onTapGesture {
                withAnimation { selected = tab }
            }
            .overlay(
                VStack {
                    Spacer()
                    if selected == tab {
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: 20, height: 2)
                            .offset(y: 8)
                    }
                }
            )
    }
}
