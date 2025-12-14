//
//  ContentView.swift
//  SwiperIOS
//
//  Created by xc z on 2025/12/13.
//

import SwiftUI
import UIKit

// 视图将从单独的文件中加载





// 主内容视图
struct MainContentView: View {
    @State private var selectedTab: TabItem = .home
    @State private var showPostModal: Bool = false
    @State private var hasNewMessage: Bool = true
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // 内容区域 - 占据剩余全部空间
                contentView
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // 底部导航栏 - 位于底部且平分5部分
                TabBar(
                    selectedTab: $selectedTab,
                    showPostModal: $showPostModal,
                    hasNewMessage: hasNewMessage
                )
            }
            
            // 发布弹窗
            if showPostModal {
                PostModalView(isPresented: $showPostModal)
            }
        }
        // 实现底部沉浸模式，保留状态栏
        .edgesIgnoringSafeArea(.bottom)
    }
    
    @ViewBuilder
    private var contentView: some View {
        switch selectedTab {
        case .home:
            HomeView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .album:
            AlbumView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .publish:
            PublishView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .message:
            MessageView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .me:
            MeView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct ContentView: View {
    var body: some View {
        MainContentView()
    }
}

#Preview {
    ContentView()
}
