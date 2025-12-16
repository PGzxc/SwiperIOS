//
//  ImageData.swift
//  SwiperIOS
//
//  Created by xc z on 2025/12/16.
//

import Foundation
import ObjectMapper

class ImageData: Mappable {

var code: Int? //状态码
var message: String? //状态描述
var data: [ImageInfo]? //图片数据
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

class ImageInfo: Mappable,Identifiable {
    var id: Int?
    var fileName: String? //文件名，需要拼接：https://api.apiopen.top/api/files/e460e35c-0bd8-4c41-a627-e0749a6b96c1.png
    var originalName: String? //原始文件名
    var size: Double? //文件大小
    var mimeType: String? //文件类型
    var fileType: String? //文件类型
    var uploader: UploadResponse? //上传者信息
    var uploadTime: String? //上传时间
    var commentsCont: Int? //评论数
    var likesCont: Int? //点赞数
    var sharesCont: Int? //分享数
    
    
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
    }
}

  
