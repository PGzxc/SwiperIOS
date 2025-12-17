import SwiftUI
import ObjectMapper

struct ImageRow: View {
    let image: ImageInfo
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let fileName = image.fileName {
                AsyncImage(url: URL(string: "https://api.apiopen.top/api/files/\(fileName)")) {
                    phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 100, height: 100)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                            .cornerRadius(8)
                    case .failure:
                        Image(systemName: "photo")
                            .frame(width: 100, height: 100)
                            .foregroundStyle(.gray)
                    @unknown default:
                        Text("未知状态")
                    }
                }
            }
            
            if let originalName = image.originalName {
                Text(originalName)
                    .font(.headline)
                    .foregroundStyle(.black)
                    .lineLimit(2)
            }
            
            if let uploader = image.uploader?.nickname {
                Text("上传者: \(uploader)")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
            
            if let uploadTime = image.uploadTime {
                Text("上传时间: \(uploadTime)")
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            
            HStack(spacing: 16) {
                if let comments = image.commentsCont {
                    Text("评论: \(comments)")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
                
                if let likes = image.likesCont {
                    Text("点赞: \(likes)")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
                
                if let shares = image.sharesCont {
                    Text("分享: \(shares)")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
            }
        }
        .padding(.vertical, 8)
    }
}