import Foundation
import ObjectMapper
import Alamofire
import Combine

class AlbumViewModel: ObservableObject {
    @Published var images: [ImageInfo] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private var page: Int = 1
    private var size: Int = 10
    
    func loadImages() {
        isLoading = true
        errorMessage = nil
        
        // 使用APIService请求图片列表
        APIService.shared.getImageList(
            page: page,
            size: size
        ) { (result: Result<APIResponse<[ImageInfo]>, APIError>) in
            DispatchQueue.main.async {
                self.isLoading = false
                
                switch result {
                case .success(let response):
                    print("APIService Image Response:")
                    print("Code: \(response.code ?? -1)")
                    print("Message: \(response.message ?? String())")
                    print("Data: \(String(describing: response.data))")
                    print("Total: \(response.total ?? 0)")
                    
                    if let imageList = response.data {
                        self.images = imageList
                        print("Image count: \(imageList.count)")
                    } else {
                        self.errorMessage = "没有找到图片数据"
                    }
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    print("APIService Image Error: \(error)")
                }
            }
        }
    }
}