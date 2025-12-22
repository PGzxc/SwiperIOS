import SwiftUI
import Combine

enum HomeTab {
    case city
    case focus
    case recommend
}

struct HomeView: View {
    @State private var selectedTab: HomeTab = .recommend
    
    // ViewModels for each tab
    @StateObject private var cityVM = VideoListViewModel(category: .city)
    @StateObject private var focusVM = VideoListViewModel(category: .focus)
    @StateObject private var recommendVM = VideoListViewModel(category: .recommend)
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .top) {
                // 1. Main Content - Swipeable Tabs
                // - Fills the entire HomeView area
                // - Extends behind status bar (ignoresSafeArea)
                TabView(selection: $selectedTab) {
                    CityView(viewModel: cityVM, tabBarHeight: 49)
                        .tag(HomeTab.city)
                        .ignoresSafeArea()
                    
                    FocusView(viewModel: focusVM, tabBarHeight: 49)
                        .tag(HomeTab.focus)
                        .ignoresSafeArea()
                    
                    RecommondView(viewModel: recommendVM, tabBarHeight: 49)
                        .tag(HomeTab.recommend)
                        .ignoresSafeArea()
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .ignoresSafeArea()
                
                // 2. Top Tab Bar
                // - Floating on top of content
                // - Positioned below Dynamic Island/Notch
                // - Uses a safe fallback if safeAreaInsets is 0 (e.g. some simulator states)
                // - Supports click switching
                TopTabBar(selected: $selectedTab)
                    .padding(.top, max(proxy.safeAreaInsets.top, 47)) // 47 is typical Dynamic Island height, ensures it's never 0
                    .background(
                        // Subtle gradient to ensure visibility against bright videos
                        LinearGradient(
                            gradient: Gradient(colors: [Color.black.opacity(0.3), Color.clear]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: 150) // Taller gradient to cover status bar area
                        .offset(y: -50) // Shift up to cover status bar
                        .allowsHitTesting(false) // Pass touches through gradient
                    )
            }
        }
        .ignoresSafeArea(edges: .top) // Ensure GeometryReader fills top
    }
}

#Preview {
    HomeView()
        .preferredColorScheme(.dark)
}
