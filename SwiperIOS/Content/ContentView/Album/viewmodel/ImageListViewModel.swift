import Foundation
import Combine
import Alamofire

class ImageListViewModel: ObservableObject {
    @Published var images: [ImageInfo] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private var page: Int = 1
    private var size: Int = 20
    private var canLoadMore: Bool = true
    
    enum Category: String, CaseIterable {
        case animal, beauty, car, comic, food, game, movie, person, phone, scenery
        var title: String {
            switch self {
            case .animal: return "动物"
            case .beauty: return "美女"
            case .car: return "汽车"
            case .comic: return "漫画"
            case .food: return "食物"
            case .game: return "游戏"
            case .movie: return "电影"
            case .person: return "摄影"
            case .phone: return "壁纸"
            case .scenery: return "风景"
            }
        }
    }
    
    let category: Category
    
    init(category: Category) {
        self.category = category
    }
    
    func loadIfNeeded() {
        if images.isEmpty {
            loadImages(reset: true)
        }
    }
    
    func loadNextPage() {
        if !isLoading && canLoadMore {
            page += 1
            loadImages(reset: false)
        }
    }
    
    func loadImages(reset: Bool = false) {
        if reset {
            page = 1
            canLoadMore = true
            images = []
            errorMessage = nil
        }
        isLoading = true
        errorMessage = nil
        APIService.shared.getImageList(
            page: page,
            size: size,
            category: category.rawValue
        ) { [weak self] (result: Result<APIResponse<[ImageInfo]>, APIError>) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    if let list = response.data {
                        if reset {
                            self.images = list
                        } else {
                            self.images.append(contentsOf: list)
                        }
                        if list.count < self.size {
                            self.canLoadMore = false
                        }
                    } else {
                        self.canLoadMore = false
                        self.errorMessage = "没有找到图片数据"
                    }
                case .failure(let error):
                    if reset {
                        self.errorMessage = error.localizedDescription
                    }
                }
            }
        }
    }
}
