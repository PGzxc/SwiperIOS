import Foundation
import Combine
import Alamofire

class VideoListViewModel: ObservableObject {
    @Published var videos: [VideoInfo] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private var page: Int = 1
    private var size: Int = 10
    private var canLoadMore: Bool = true
    
    // Enum to distinguish different video categories if needed
    enum Category {
        case city
        case focus
        case recommend
    }
    
    let category: Category
    
    init(category: Category) {
        self.category = category
    }
    
    func loadIfNeeded() {
        if videos.isEmpty {
            loadVideos(reset: true)
        }
    }
    
    func loadNextPage() {
        if !isLoading && canLoadMore {
            page += 1
            loadVideos(reset: false)
        }
    }
    
    func loadVideos(reset: Bool = false) {
        if reset {
            page = 1
            canLoadMore = true
            videos = []
        }
        
        isLoading = true
        errorMessage = nil
        
        // Construct parameters based on category if API supports it
        // For now using same endpoint but in real app would use different params
        var params: [String: Any] = [
            "page": page,
            "size": size
        ]
        
        // Example: if API supported type
        // params["type"] = category == .city ? "city" : (category == .focus ? "focus" : "recommend")
        
        APIClient.shared.requestArray(
            "api/videos",
            method: .get,
            parameters: params,
            headers: nil,
            encoding: URLEncoding.default
        ) { [weak self] (result: Result<APIResponse<[VideoInfo]>, APIError>) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                
                switch result {
                case .success(let response):
                    if let videoList = response.data {
                        // 为计数赋随机值（1-10000），并兼容老/新字段
                        for v in videoList {
                            if v.likesCont == nil || (v.likesCont ?? 0) <= 0 {
                                v.likesCont = Int.random(in: 1...10000)
                            }
                            if v.commentsCont == nil || (v.commentsCont ?? 0) <= 0 {
                                v.commentsCont = Int.random(in: 1...10000)
                            }
                            if v.collectCont == nil || (v.collectCont ?? 0) <= 0 {
                                v.collectCont = Int.random(in: 1...10000)
                            }
                            // 兼容 sharesCont 与 shareCont
                            if v.shareCont == nil, let oldShare = v.sharesCont {
                                v.shareCont = oldShare
                            }
                            if v.shareCont == nil || (v.shareCont ?? 0) <= 0 {
                                v.shareCont = Int.random(in: 1...10000)
                            }
                        }
                        if reset {
                            self.videos = videoList
                        } else {
                            self.videos.append(contentsOf: videoList)
                        }
                        
                        // Check if we reached end of list
                        if videoList.count < self.size {
                            self.canLoadMore = false
                        }
                    } else {
                        if reset {
                            self.errorMessage = "没有找到视频数据"
                        }
                        self.canLoadMore = false
                    }
                case .failure(let error):
                    if reset {
                        self.errorMessage = error.localizedDescription
                    }
                    print("API Error: \(error)")
                }
            }
        }
    }
}
