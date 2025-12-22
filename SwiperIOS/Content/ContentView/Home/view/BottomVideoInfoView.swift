import SwiftUI

struct BottomVideoInfoView: View {
    let video: VideoInfo
    
    private func processedTitle() -> String {
        let raw = video.originalName ?? video.fileName ?? ""
        if raw.lowercased().hasSuffix(".mp4") {
            return String(raw.dropLast(4))
        }
        return raw
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Username
            Text("@\(video.uploader?.nickname ?? "未知用户")")
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .semibold))
                .shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 1)

            // Description
            Text(processedTitle())
                .foregroundColor(.white)
                .font(.system(size: 14))
                .lineLimit(2)
                .shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 1)
            
            // Music info
            HStack(spacing: 6) {
                Image(systemName: "megaphone.fill")
                    .foregroundColor(.white)
                    .font(.system(size: 12))
                
                Text("作者声明：内容来源于网络")
                    .foregroundColor(.white)
                    .font(.system(size: 13))
                    .lineLimit(1)
            }
            .padding(.top, 4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 12)
        .padding(.trailing, 80) // Leave space for RightActionBar
        .padding(.bottom, 20)
    }
}
