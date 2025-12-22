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
            // 背景色 - 确保沉浸式体验
            Color.black.ignoresSafeArea()
            
            // Flex Layout: Content + BottomTabBar
            VStack(spacing: 0) {
                // 1. 内容区域 (Content Area)
                // - 占据剩余全部空间 (flexgrow 1)
                // - 背景透明 (transparent)
                // - 穿透状态栏 (ignoresSafeArea .top)
                contentView
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.clear)
                    .ignoresSafeArea(edges: .top) // 关键：让内容区域延伸到状态栏
                
                // 2. 底部导航栏 (Bottom TabBar)
                // - 固定在底部
                // - 背景黑色 (不透明)
                TabBar(
                    selectedTab: $selectedTab,
                    showPostModal: $showPostModal,
                    hasNewMessage: hasNewMessage
                )
                .background(Color.black)
            }
            .background(Color.clear) // VStack容器背景透明
            .ignoresSafeArea(edges: .top) // 关键：让VStack整体延伸到顶部
            
            // 发布弹窗
            if showPostModal {
                PostModalView(isPresented: $showPostModal)
            }
        }
        // 仅忽略底部安全区域（让TabBar贴底），顶部已经在VStack中处理
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
        .preferredColorScheme(.dark)
}
