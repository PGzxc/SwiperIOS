import SwiftUI
import ObjectMapper
import Alamofire
import Combine

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        ZStack {
            Color.white
            
            if viewModel.isLoading {
                ProgressView("加载中...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .font(.title3)
                    .foregroundStyle(.black)
            } else if let error = viewModel.errorMessage {
                VStack {
                    Text("加载失败")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.red)
                        .padding()
                    Text(error)
                        .font(.body)
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.center)
                        .padding()
                    Button(action: viewModel.loadVideos) {
                        Text("重试")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                }
            } else {
                List(viewModel.videos, id: \.id) { video in
                    VideoRow(video: video)
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("视频列表")
        .onAppear {
            viewModel.loadVideos()
        }
    }
}

#Preview {
    HomeView()
}