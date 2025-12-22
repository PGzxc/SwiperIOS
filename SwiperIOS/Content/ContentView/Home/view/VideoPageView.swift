import SwiftUI
import AVKit
import CoreMedia
import AVFoundation

struct VideoPageView: View {
    let video: VideoInfo
    var tabBarHeight: CGFloat = 49
    var pageIndex: Int? = nil
    @Binding var currentIndex: Int
    @State private var player: AVPlayer? = nil
    @State private var isPlaying: Bool = true
    @State private var isLoading: Bool = true
    @State private var timeObserver: Any? = nil
    @State private var isSwipingPages: Bool = false

    var body: some View {
        GeometryReader { proxy in
            // Video should fill the parent content area height (ContentView area)
            // Parent (VerticalPageView) fills contentView.
            // contentView spans from Top of Screen to Top of BottomTabBar.
            let videoHeight = proxy.size.height

            ZStack {
                // 1. Video Layer
                // - Tiled, fills entire page
                // - Penetrates Status Bar (ignoresSafeArea .top)
                if let file = video.fileName, let url = URL(string: "https://api.apiopen.top/api/files/\(file)") {
                    PlayerLayerView(player: player)
                        .frame(width: proxy.size.width, height: videoHeight)
                        .clipped()
                        .ignoresSafeArea(edges: .top)
                        .onAppear {
                            if player == nil {
                                player = AVPlayer(url: url)
                            }
                            if let idx = pageIndex {
                                if currentIndex == idx {
                                    player?.play(); isPlaying = true
                                } else {
                                    player?.pause(); isPlaying = false
                                }
                            } else {
                                player?.play(); isPlaying = true
                            }
                            isLoading = true
                            let interval = CMTime(seconds: 0.2, preferredTimescale: 600)
                            timeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { _ in
                                guard let p = player else { return }
                                isLoading = (p.timeControlStatus == .waitingToPlayAtSpecifiedRate)
                            }
                        }
                        .onDisappear {
                            player?.pause()
                            isPlaying = false
                            isLoading = false
                            if let t = timeObserver {
                                player?.removeTimeObserver(t)
                                timeObserver = nil
                            }
                        }
                } else {
                    Color.black.frame(height: videoHeight)
                    Text("视频地址无效")
                        .foregroundColor(.white)
                }

                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                }

                // 2. UI Components Overlay
                // - Right Action Bar
                // - Bottom Video Bar
                // - These scroll WITH the video because they are inside this VideoPageView
                VStack {
                    Spacer()
                    
                    HStack(alignment: .bottom) {
                        // Bottom Info (Left)
                        BottomVideoInfoView(video: video)
                            .layoutPriority(1)
                        
                        Spacer()
                        
                        // Right Actions (Right)
                        RightActionBar(video: video)
                    }
                    .padding(.bottom, 20) // Spacing from bottom (above Bottom TabBar)
                }
                
                // 3. Play/Pause interactions (no visible button in vertical swipe mode)
                if isPlaying {
                    Color.clear
                        .frame(width: proxy.size.width * 0.5, height: proxy.size.height * 0.5)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            guard let p = player else { return }
                            p.pause()
                            isPlaying = false
                            isLoading = false
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                } else {
                    if !isSwipingPages {
                        // Show center play button only when paused and not swiping pages
                        Button(action: {
                            guard let p = player else { return }
                            p.play()
                            isPlaying = true
                            isLoading = false
                        }) {
                            Image(systemName: "play.circle.fill")
                                .resizable()
                                .frame(width: 64, height: 64)
                                .foregroundColor(.white)
                                .opacity(0.9)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    } else {
                        Color.clear.frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
            }
            .frame(width: proxy.size.width, height: videoHeight)
            .background(Color.black)
            .ignoresSafeArea(edges: .top) // Ensure everything here can go behind status bar
            .onReceive(NotificationCenter.default.publisher(for: .verticalPageDidShow)) { note in
                guard let info = note.userInfo, let idx = info["index"] as? Int else { return }
                // handled by binding
            }
            .onReceive(NotificationCenter.default.publisher(for: .AVPlayerItemNewAccessLogEntry)) { _ in
                if let p = player, p.timeControlStatus == .playing {
                    isLoading = false
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: .AVPlayerItemPlaybackStalled)) { _ in
                isLoading = true
            }
            .onReceive(NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime)) { _ in
                guard let p = player else { return }
                p.seek(to: .zero)
                if isPlaying {
                    p.play()
                    isLoading = false
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: .verticalPageWillTransition)) { _ in
                isSwipingPages = true
            }
            .onReceive(NotificationCenter.default.publisher(for: .verticalPageDidEndTransition)) { _ in
                isSwipingPages = false
            }
            .onChange(of: currentIndex) { newVal in
                guard let idx = pageIndex else { return }
                if newVal == idx {
                    player?.play(); isPlaying = true
                    isLoading = false
                } else {
                    player?.pause(); isPlaying = false
                    isLoading = false
                }
            }
        }
    }
}
