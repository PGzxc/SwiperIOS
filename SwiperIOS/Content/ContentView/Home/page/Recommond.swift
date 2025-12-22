import SwiftUI

struct RecommondView: View {
    @ObservedObject var viewModel: VideoListViewModel
    var tabBarHeight: CGFloat = 49
    @State private var currentIndex: Int = 0

    var body: some View {
        ZStack {
            if viewModel.videos.isEmpty {
                if viewModel.isLoading {
                    ProgressView("加载中...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else if let err = viewModel.errorMessage {
                    Text(err).foregroundColor(.white)
                } else {
                    Color.black
                }
            } else {
                VerticalPageView(pages: viewModel.videos.enumerated().map { (idx, info) in
                    VideoPageView(video: info, tabBarHeight: tabBarHeight, pageIndex: idx, currentIndex: $currentIndex)
                }, currentIndex: $currentIndex)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .onAppear { viewModel.loadIfNeeded() }
        .onChange(of: currentIndex) { newIndex in
            if newIndex >= viewModel.videos.count - 1 {
                viewModel.loadNextPage()
            }
        }
    }
}
