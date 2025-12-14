import SwiftUI
import UIKit

// 导航项枚举
enum TabItem: Int, CaseIterable {
    case home
    case album
    case publish
    case message
    case me
    
    var title: String {
        switch self {
        case .home: return "首页"
        case .album: return "图集"
        case .publish: return ""
        case .message: return "消息"
        case .me: return "我"
        }
    }
    
    var iconName: String {
        switch self {
        case .home: return ""
        case .album: return ""
        case .publish: return "plus.circle"
        case .message: return ""
        case .me: return ""
        }
    }
}

// 底部导航项组件
struct TabBarItem: View {
    let item: TabItem
    let isSelected: Bool
    let hasNewMessage: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                // 只有当iconName不为空时才显示图标
                if !item.iconName.isEmpty {
                    if item == .publish {
                        // 发布图标：007AFF蓝色填充，白色+号
                        ZStack {
                            Circle()
                                .fill(Color(red: 0/255, green: 122/255, blue: 255/255)) // #007AFF
                                .frame(width: 36, height: 36)
                            Image(systemName: "plus")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundStyle(.white)
                        }
                        .frame(height: 36) // 确保与其他导航项高度一致
                    } else {
                        Image(systemName: item.iconName)
                            .font(.system(size: 24))
                            .foregroundStyle(isSelected ? .black : .gray)
                    }
                }
                
                // 只有当title不为空时才显示文字
                if !item.title.isEmpty {
                    // 使用ZStack定位文字和红点
                    ZStack {
                        Text(item.title)
                        .font(isSelected ? .system(size: 16, weight: .bold) : .system(size: 13, weight: .regular))
                        .foregroundStyle(isSelected ? .black : .gray)
                        
                        // 消息红点提示 - 位于文字右上角
                        if item == .message && hasNewMessage {
                            Circle()
                                .fill(.red)
                                .frame(width: 12, height: 12)
                                .offset(x: isSelected ? 16 : 13, y: isSelected ? -16 : -13)
                        }
                    }
                }
            }
            .scaleEffect(isSelected ? 1.2 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        }
        .frame(maxWidth: .infinity)
    }
}

// 底部导航栏组件
struct TabBar: View {
    @Binding var selectedTab: TabItem
    @Binding var showPostModal: Bool
    let hasNewMessage: Bool
    
    var body: some View {
        HStack {
            ForEach(TabItem.allCases, id: \.rawValue) { item in
                TabBarItem(
                    item: item,
                    isSelected: selectedTab == item,
                    hasNewMessage: hasNewMessage,
                    action: {
                        if item == .publish {
                            showPostModal = true
                        } else {
                            selectedTab = item
                        }
                    }
                )
            }
        }
        .padding(.bottom, 20)
        .padding(.top, 10)
    }
}