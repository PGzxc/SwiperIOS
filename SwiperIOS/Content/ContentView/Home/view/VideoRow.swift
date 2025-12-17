import SwiftUI
import ObjectMapper

struct VideoRow: View {
    let video: VideoInfo
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let title = video.fileName {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.black)
                    .lineLimit(2)
            }
            
            if let uploader = video.uploader?.nickname {
                Text("上传者: \(uploader)")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
            
            if let uploadTime = video.uploadTime {
                Text("上传时间: \(uploadTime)")
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            
            HStack(spacing: 16) {
                if let comments = video.commentsCont {
                    Text("评论: \(comments)")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
                
                if let likes = video.likesCont {
                    Text("点赞: \(likes)")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
                
                if let shares = video.sharesCont {
                    Text("分享: \(shares)")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
            }
        }
        .padding(.vertical, 8)
    }
}