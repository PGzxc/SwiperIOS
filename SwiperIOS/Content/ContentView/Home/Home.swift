import SwiftUI
import ObjectMapper
import Alamofire

struct HomeView: View {
    @State private var videos: [VideoInfo] = []
    @State private var isLoading: Bool = false
    @State private var errorMessage: String? = nil
    @State private var page: Int = 1
    @State private var size: Int = 10
    
    var body: some View {
        ZStack {
            Color.white
            
            if isLoading {
                ProgressView("加载中...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .font(.title3)
                    .foregroundStyle(.black)
            } else if let error = errorMessage {
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
                    Button(action: loadVideos) {
                        Text("重试")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                }
            } else {
                List(videos, id: \.id) { video in
                    VideoRow(video: video)
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("视频列表")
        .onAppear {
            loadVideos()
        }
    }
    
    private func loadVideos() {
        isLoading = true
        errorMessage = nil
        
        // 使用APIClient请求视频列表
        APIClient.shared.requestArray(
            "api/videos",
            method: .get,
            parameters: ["page": page, "size": size],
            headers: nil,
            encoding: URLEncoding.default
        ) { (result: Result<APIResponse<[VideoInfo]>, APIError>) in
            DispatchQueue.main.async {
                self.isLoading = false
                
                switch result {
                case .success(let response):
                    print("APIClient Response:")
                    print("Code: \(response.code ?? -1)")
                    print("Message: \(response.message ?? String())")
                    print("Data: \(String(describing: response.data))")
                    print("Total: \(response.total ?? 0)")
                    
                    if let videoList = response.data {
                        self.videos = videoList
                        print("Video count: \(videoList.count)")
                    } else {
                        self.errorMessage = "没有找到视频数据"
                    }
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    print("APIClient Error: \(error)")
                }
            }
        }
    }
}

struct VideoRow: View {
    let video: VideoInfo
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let title = video.fileName {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.black)
                    .lineLimit(2)
            }
            
            if let uploader = video.uploader?.nickname {
                Text("上传者: \(uploader)")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
            
            if let uploadTime = video.uploadTime {
                Text("上传时间: \(uploadTime)")
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            
            HStack(spacing: 16) {
                if let comments = video.commentsCont {
                    Text("评论: \(comments)")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
                
                if let likes = video.likesCont {
                    Text("点赞: \(likes)")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
                
                if let shares = video.sharesCont {
                    Text("分享: \(shares)")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    HomeView()
}