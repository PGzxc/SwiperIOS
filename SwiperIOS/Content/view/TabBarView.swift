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
    
    var selectedColor: Color {
        switch self {
        case .home: return Color(red: 0/255, green: 122/255, blue: 255/255) // #007AFF
        case .album: return Color(red: 0/255, green: 184/255, blue: 148/255) // #00B894
        case .publish: return Color(red: 255/255, green: 108/255, blue: 0/255) // #FF6C00
        case .message: return Color(red: 255/255, green: 78/255, blue: 78/255) // #FF4E4E
        case .me: return Color(red: 103/255, green: 58/255, blue: 183/255) // #673AB7
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
                        // 发布图标使用其特定颜色
                        ZStack {
                            Circle()
                                .fill(item.selectedColor) // 使用selectedColor
                                .frame(width: 36, height: 36)
                            Image(systemName: "plus")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundStyle(.white)
                        }
                        .frame(height: 36) // 确保与其他导航项高度一致
                    } else {
                        Image(systemName: item.iconName)
                            .font(.system(size: 24))
                            .foregroundStyle(isSelected ? item.selectedColor : .gray)
                    }
                }
                
                // 只有当title不为空时才显示文字
                if !item.title.isEmpty {
                    // 使用ZStack定位文字和红点
                    ZStack {
                        Text(item.title)
                        .font(isSelected ? .system(size: 16, weight: .bold) : .system(size: 13, weight: .regular))
                        .foregroundStyle(isSelected ? item.selectedColor : .gray)
                        
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
        .background(Color.white)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: -5)
        .edgesIgnoringSafeArea(.bottom)
    }
}