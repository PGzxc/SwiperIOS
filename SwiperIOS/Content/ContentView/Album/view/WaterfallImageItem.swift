import SwiftUI
 
struct WaterfallImageItem: View {
    let image: ImageInfo
    let width: CGFloat
    let onTap: (ImageInfo) -> Void
    
    var body: some View {
        let height = width * 2
        let urlString = image.fileName.flatMap { "https://api.apiopen.top/api/files/\($0)" }
        ZStack(alignment: .bottom) {
            if let urlStr = urlString, let url = URL(string: urlStr) {
                AsyncImage(url: url) { img in
                    img.resizable().scaledToFill()
                } placeholder: {
                    Color.gray.opacity(0.2)
                }
                .frame(width: width, height: height)
                .clipped()
                .cornerRadius(8)
                .onTapGesture { onTap(image) }
            } else {
                Color.gray.opacity(0.2)
                    .frame(width: width, height: height)
                    .cornerRadius(8)
                    .onTapGesture { onTap(image) }
            }
            VStack(spacing: 6) {
                HStack {
                    Text(image.originalName ?? image.fileName ?? "")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.white)
                        .lineLimit(1)
                    Spacer()
                }
                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 13))
                            .foregroundColor(.white)
                        Text(formatCount(image.likesCont ?? stableCount(image.fileName ?? "\(image.id ?? 0)", max: 1000)))
                            .font(.system(size: 12))
                            .foregroundColor(.white)
                    }
                    Spacer()
                    HStack(spacing: 4) {
                        Image(systemName: "ellipsis.bubble.fill")
                            .font(.system(size: 13))
                            .foregroundColor(.white)
                        Text(formatCount(image.commentsCont ?? stableCount((image.originalName ?? image.fileName ?? "\(image.id ?? 0)") + "c", max: 1000)))
                            .font(.system(size: 12))
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 8)
            .frame(width: width, alignment: .bottom)
            .background(Color.black.opacity(0.6))
        }
    }
    
    private func formatCount(_ count: Int) -> String {
        if count >= 10_000 {
            return String(format: "%.1fw", Double(count) / 10_000.0)
        }
        return "\(count)"
    }
    
    private func stableCount(_ seed: String, max: Int) -> Int {
        let v = abs(seed.hashValue % max)
        return (v == 0) ? 1 : v
    }
}
