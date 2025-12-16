import Foundation
import Alamofire
import ObjectMapper

class APIClient {
    // Singleton instance
    static let shared = APIClient()
    
    // Base URL for all API requests
    private let baseURL = "https://api.apiopen.top/"
    
    // Alamofire session with custom configuration
    private let session: Session
    
    // Private initializer to prevent external instantiation
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30.0
        configuration.timeoutIntervalForResource = 30.0
        // Set default Content-Type header to application/json
//        configuration.headers = [
//            "Content-Type": "application/json"
//        ]
        
        session = Session(configuration: configuration)
    }
    
    // MARK: - Request Methods (Trailing Closure)
    
    // Generic request method with trailing closure
    func request<T: Mappable>(
        _ endpoint: String,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        completion: @escaping (Result<APIResponse<T>, APIError>) -> Void
    ) {
        let url = baseURL + endpoint
        
        session.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
            .validate(statusCode: 200..<300)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    self.parseResponse(data: data, completion: completion)
                case .failure(let error):
                    completion(.failure(error.toAPIError()))
                }
            }
    }
    
    // Request method for array responses with trailing closure
    func requestArray<T: Mappable>(
        _ endpoint: String,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        completion: @escaping (Result<APIResponse<[T]>, APIError>) -> Void
    ) {
        let url = baseURL + endpoint
        
        session.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
            .validate(statusCode: 200..<300)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    self.parseResponse(data: data, completion: completion)
                case .failure(let error):
                    completion(.failure(error.toAPIError()))
                }
            }
    }
    
    // MARK: - Request Methods (Async/Await)
    
    // Generic request method with async/await
    func request<T: Mappable>(
        _ endpoint: String,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil,
        encoding: ParameterEncoding = URLEncoding.default
    ) async throws -> APIResponse<T> {
        try await withCheckedThrowingContinuation { continuation in
            request(endpoint, method: method, parameters: parameters, headers: headers, encoding: encoding) {
                (result: Result<APIResponse<T>, APIError>) in
                switch result {
                case .success(let response): continuation.resume(returning: response)
                case .failure(let error): continuation.resume(throwing: error)
                }
            }
        }
    }
    
    // Request method for array responses with async/await
    func requestArray<T: Mappable>(
        _ endpoint: String,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil,
        encoding: ParameterEncoding = URLEncoding.default
    ) async throws -> APIResponse<[T]> {
        try await withCheckedThrowingContinuation { continuation in
            requestArray(endpoint, method: method, parameters: parameters, headers: headers, encoding: encoding) {
                (result: Result<APIResponse<[T]>, APIError>) in
                switch result {
                case .success(let response): continuation.resume(returning: response)
                case .failure(let error): continuation.resume(throwing: error)
                }
            }
        }
    }
    
    // MARK: - File Upload
    
    // Upload file with trailing closure
    func upload<T: Mappable>(
        _ endpoint: String,
        fileURL: URL,
        method: HTTPMethod = .post,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil,
        completion: @escaping (Result<APIResponse<T>, APIError>) -> Void
    ) {
        let url = baseURL + endpoint
        
        session.upload(
            multipartFormData: { multipartFormData in
                // Add file data
                multipartFormData.append(fileURL, withName: "file")
                
                // Add parameters if any
                if let parameters = parameters {
                    for (key, value) in parameters {
                        if let stringValue = value as? String {
                            multipartFormData.append(stringValue.data(using: .utf8)!, withName: key)
                        } else if let dataValue = value as? Data {
                            multipartFormData.append(dataValue, withName: key)
                        }
                    }
                }
            },
            to: url,
            method: method,
            headers: headers
        )
        .validate(statusCode: 200..<300)
        .responseData { response in
            switch response.result {
            case .success(let data):
                self.parseResponse(data: data, completion: completion)
            case .failure(let error):
                completion(.failure(error.toAPIError()))
            }
        }
    }
    
    // MARK: - Private Helper Methods
    
    // Parse JSON response using ObjectMapper
    private func parseResponse<T>(data: Data, completion: (Result<APIResponse<T>, APIError>) -> Void) where T: Mappable {
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                if let response = Mapper<APIResponse<T>>().map(JSON: json) {
                    completion(.success(response))
                } else {
                    completion(.failure(.parsingError(NSError(domain: "APIClient", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to map response"]))))
                }
            } else {
                completion(.failure(.parsingError(NSError(domain: "APIClient", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON format"]))))
            }
        } catch {
            completion(.failure(.parsingError(error)))
        }
    }
    
    // Parse JSON response for array types
    private func parseResponse<T>(data: Data, completion: (Result<APIResponse<[T]>, APIError>) -> Void) where T: Mappable {
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                // 单独解析APIResponse的其他字段
                let response = APIResponse<[T]>()
                response.code = json["code"] as? Int
                response.message = json["message"] as? String
                response.total = json["total"] as? Int
                response.page = json["page"] as? Int
                response.size = json["size"] as? Int
                
                // 单独解析data数组
                if let dataArray = json["data"] as? [[String: Any]] {
                    response.data = dataArray.compactMap { Mapper<T>().map(JSON: $0) }
                }
                
                completion(.success(response))
            } else {
                completion(.failure(.parsingError(NSError(domain: "APIClient", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON format"]))))
            }
        } catch {
            completion(.failure(.parsingError(error)))
        }
    }
}
