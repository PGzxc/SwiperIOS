import Foundation
import ObjectMapper

class VideoData: Mappable {

var code: Int? //状态码
var message: String? //状态描述
var data: [VideoInfo]? //视频数据
var total: Int? //视频总数
var page: Int? //当前页码
var size: Int? //每页视频数

required init?(map: Map) {
        
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

class VideoInfo: Mappable,Identifiable {
    var id: Int?
    var fileName: String? //文件名，需要拼接：https://api.apiopen.top/api/files/e460e35c-0bd8-4c41-a627-e0749a6b96c1.mp4
    var originalName: String? //原始文件名
    var size: Double? //文件大小
    var mimeType: String? //文件类型
    var fileType: String? //文件类型
    var uploader: UploadResponse? //上传者信息
    var uploadTime: String? //上传时间
    var commentsCont: Int? //评论数
    var likesCont: Int? //点赞数
    var sharesCont: Int? //分享数（旧字段）
    var shareCont: Int? //分享数（新字段）
    var collectCont: Int? //收藏数
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map:Map) {
        id <- map["id"]
        fileName <- map["fileName"]
        originalName <- map["originalName"]
        size <- map["size"]
        mimeType <- map["mimeType"]
        fileType <- map["fileType"]
        uploader <- map["uploader"]
        uploadTime <- map["uploadTime"]
        commentsCont <- map["commentsCont"]
        likesCont <- map["likesCont"]
        sharesCont <- map["sharesCont"]
        shareCont <- map["shareCont"]
        collectCont <- map["collectCont"]
        
        // 兼容老字段：若新字段为空且旧字段不为空，则赋值到新字段
        if shareCont == nil, let old = sharesCont {
            shareCont = old
        }
    }
}

class UploadResponse: Mappable,Identifiable {
    var account_id: Int?
    var email: String? //邮箱
    var nickname: String? //昵称
    var avatar: String? //头像
    var bio: String? //个人介绍
    var gender: String? //性别 female male
    var age: Int? //年龄
    var location: String? //位置
    var created_at: String? //创建时间
    var updated_at: String? //更新时间
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        account_id <- map["account_id"]
        email <- map["email"]
        nickname <- map["nickname"]
        avatar <- map["avatar"]
        bio <- map["bio"]
        gender <- map["gender"]
        age <- map["age"]
        location <- map["location"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
    }
}
    
