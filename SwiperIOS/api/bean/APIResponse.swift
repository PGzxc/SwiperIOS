import Foundation
import ObjectMapper

class APIResponse<T>: Mappable {
    var code: Int?
    var message: String?
    var data: T?
    var total: Int?
    var page: Int?
    var size: Int?
    
    // Default initializer
    init() {}
    
    required init?(map: Map) {
        // Required by Mappable protocol
    }
    
    func mapping(map: Map) {
        code <- map["code"]
        message <- map["message"]
        data <- map["data"]
        total <- map["total"]
        page <- map["page"]
        size <- map["size"]
    }
}
