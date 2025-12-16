import Foundation
import Alamofire
import ObjectMapper

class APIService {
    // Singleton instance
    static let shared = APIService()
    
    private init() {
        // Private initialization to ensure singleton
    }
    
    // MARK: - Video API Methods (Trailing Closure)
    
    // Get video list with trailing closure
    func getVideoList(
        page: Int,
        size: Int,
        completion: @escaping (Result<APIResponse<[VideoInfo]>, APIError>) -> Void
    ) {
        let parameters: Parameters = [
            "page": page,
            "size": size
        ]
        
        APIClient.shared.requestArray(
            "api/videos",
            method: .get,
            parameters: parameters,
            headers: nil,
            encoding: URLEncoding.default,
            completion: completion
        )
    }
    
    // MARK: - Video API Methods (Async/Await)
    
    // Get video list with async/await
    func getVideoList(
        page: Int,
        size: Int
    ) async throws -> APIResponse<[VideoInfo]> {
        let parameters: Parameters = [
            "page": page,
            "size": size
        ]
        
        return try await APIClient.shared.requestArray(
            "/api/videos",
            method: .get,
            parameters: parameters,
            headers: nil,
            encoding: URLEncoding.default
        )
    }
    
    // MARK: - Image API Methods (Trailing Closure)
    
    // Get image list with trailing closure
    func getImageList(
        page: Int,
        size: Int,
        completion: @escaping (Result<APIResponse<[ImageInfo]>, APIError>) -> Void
    ) {
        let parameters: Parameters = [
            "page": page,
            "size": size
        ]
        
        APIClient.shared.requestArray(
            "api/images",
            method: .get,
            parameters: parameters,
            headers: nil,
            encoding: URLEncoding.default,
            completion: completion
        )
    }
    
    // MARK: - Image API Methods (Async/Await)
    
    // Get image list with async/await
    func getImageList(
        page: Int,
        size: Int
    ) async throws -> APIResponse<[ImageInfo]> {
        let parameters: Parameters = [
            "page": page,
            "size": size
        ]
        
        return try await APIClient.shared.requestArray(
            "api/images",
            method: .get,
            parameters: parameters,
            headers: nil,
            encoding: URLEncoding.default
        )
    }
    
    // MARK: - Other API Methods (Can be added as needed)
    
    // Example: Get single video details
    func getVideoDetails(
        id: Int,
        completion: @escaping (Result<APIResponse<VideoInfo>, APIError>) -> Void
    ) {
        let parameters: Parameters = ["id": id]
        
        APIClient.shared.request(
            "getVideoDetails",
            method: .get,
            parameters: parameters,
            headers: nil,
            encoding: URLEncoding.default,
            completion: completion
        )
    }
    
    // Example: Upload video
    func uploadVideo(
        fileURL: URL,
        title: String,
        description: String,
        completion: @escaping (Result<APIResponse<VideoInfo>, APIError>) -> Void
    ) {
        let parameters: Parameters = [
            "title": title,
            "description": description
        ]
        
        APIClient.shared.upload(
            "uploadVideo",
            fileURL: fileURL,
            method: .post,
            parameters: parameters,
            headers: nil,
            completion: completion
        )
    }
}
