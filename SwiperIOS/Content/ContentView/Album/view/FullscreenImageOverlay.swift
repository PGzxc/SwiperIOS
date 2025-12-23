import SwiftUI
 
struct FullscreenImageOverlay: View {
    let image: ImageInfo
    @Binding var zoomScale: CGFloat
    let onDismiss: () -> Void
    
    var body: some View {
        let urlString = image.fileName.flatMap { "https://api.apiopen.top/api/files/\($0)" }
        ZStack {
            Color.black.opacity(0.6)
                .ignoresSafeArea()
                .contentShape(Rectangle())
                .onTapGesture { onDismiss() }
            if let urlStr = urlString, let url = URL(string: urlStr) {
                AsyncImage(url: url) { i in
                    i.resizable().scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .scaleEffect(zoomScale)
                .gesture(
                    MagnificationGesture()
                        .onChanged { value in
                            let v = max(1.0, min(value, 4.0))
                            zoomScale = v
                        }
                )
                .onTapGesture { onDismiss() }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                Color.clear.onTapGesture { onDismiss() }
            }
        }
        .transition(.opacity)
    }
}
