import Foundation
import Alamofire

enum APIError: Error {
    case invalidURL
    case networkError(Error)
    case serverError(Int)
    case parsingError(Error)
    case unknownError
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "无效的URL"
        case .networkError(let error):
            return "网络错误: \(error.localizedDescription)"
        case .serverError(let statusCode):
            return "服务器错误: 状态码 \(statusCode)"
        case .parsingError(let error):
            return "解析错误: \(error.localizedDescription)"
        case .unknownError:
            return "未知错误"
        }
    }
}

extension AFError {
    func toAPIError() -> APIError {
        switch self {
        case .invalidURL:
            return .invalidURL
        case .sessionTaskFailed(let error):
            return .networkError(error)
        case .responseValidationFailed(let reason):
            switch reason {
            case .unacceptableStatusCode(let code):
                return .serverError(code)
            default:
                return .networkError(self)
            }
        default:
            return .networkError(self)
        }
    }
}