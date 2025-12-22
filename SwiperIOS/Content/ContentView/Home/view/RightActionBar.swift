import SwiftUI

struct RightActionBar: View {
    let video: VideoInfo
    @State private var liked: Bool = false
    @State private var followed: Bool = false
    @State private var rotation: Double = 0

    var body: some View {
        VStack(spacing: 20) {
            // Avatar + Follow
            ZStack(alignment: .bottom) {
                if let avatar = video.uploader?.avatar, let url = URL(string: avatar) {
                    AsyncImage(url: url) { img in
                        img.resizable().scaledToFill()
                    } placeholder: {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable().foregroundColor(.gray)
                    }
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 1))
                } else {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.gray)
                        .overlay(Circle().stroke(Color.white, lineWidth: 1))
                }

                Button(action: { followed.toggle() }) {
                    Image(systemName: followed ? "checkmark" : "plus")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 24, height: 24)
                        .background(Color.red)
                        .clipShape(Circle())
                }
                .offset(y: 12)
            }
            .padding(.bottom, 12)

            // Like
            actionButton(icon: "heart.fill", count: video.likesCont ?? 0, color: liked ? .red : .white) {
                liked.toggle()
            }

            // Comment
            actionButton(icon: "ellipsis.bubble.fill", count: video.commentsCont ?? 0) {
                // comment
            }

            // Collect
            actionButton(icon: "bookmark.fill", count: video.collectCont ?? 0) {
                // collect
            }

            // Share
            actionButton(icon: "arrowshape.turn.up.right.fill", count: (video.shareCont ?? video.sharesCont) ?? 0) {
                // share
            }

            // Music Disc
            ZStack {
                Circle()
                    .fill(Color.black.opacity(0.8))
                    .frame(width: 50, height: 50)
                
                Image(systemName: "music.note")
                    .foregroundColor(.white)
                    .font(.system(size: 20))
                
                Circle()
                    .stroke(Color.gray.opacity(0.6), lineWidth: 10)
                    .frame(width: 30, height: 30)
                    .rotationEffect(.degrees(rotation))
            }
            .onAppear {
                rotation = 0
                withAnimation(.linear(duration: 5).repeatForever(autoreverses: false)) {
                    rotation = 360
                }
            }
            .padding(.top, 10)
        }
        .padding(.trailing, 8)
    }

    @ViewBuilder
    func actionButton(icon: String, count: Int, color: Color = .white, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 32))
                    .foregroundColor(color)
                    .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                
                Text(formatCount(count))
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 1)
            }
        }
    }
    
    func formatCount(_ count: Int) -> String {
        if count > 10000 {
            return String(format: "%.1fw", Double(count)/10000.0)
        }
        return "\(count)"
    }
}
