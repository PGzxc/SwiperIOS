import Foundation
import ObjectMapper
import Alamofire
import Combine

class HomeViewModel: ObservableObject {
    @Published var videos: [VideoInfo] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private var page: Int = 1
    private var size: Int = 10
    
    func loadVideos() {
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