import SwiftUI
import UIKit

// 发布弹窗组件
struct PostModalView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            // 半透明背景
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {
                    isPresented = false
                }
            
            // 弹窗内容
            VStack {
                Spacer()
                
                VStack(spacing: 0) {
                    // 相册选择
                    Button(action: {
                        isPresented = false
                    }) {
                        Text("从相册选择")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundStyle(.black)
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(Color.white)
                    }
                    
                    // 分割线
                    Divider()
                        .background(Color(red: 242/255, green: 242/255, blue: 242/255).opacity(0.7))
                        .frame(height: 0.4)
                    
                    // 相机
                    Button(action: {
                        isPresented = false
                    }) {
                        Text("相机")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundStyle(.black)
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(Color.white)
                    }
                    
                    // 分割线
                    Divider()
                        .background(Color(red: 242/255, green: 242/255, blue: 242/255).opacity(0.7))
                        .frame(height: 0.4)
                    
                    // 写文字
                    Button(action: {
                        isPresented = false
                    }) {
                        Text("写文字")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundStyle(.black)
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(Color.white)
                    }
                    
                    // 间隔
                    Rectangle()
                        .fill(Color(red: 242/255, green: 242/255, blue: 242/255))
                        .frame(height: 10)
                    
                    // 取消
                    Button(action: {
                        isPresented = false
                    }) {
                        Text("取消")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundStyle(.black)
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(Color.white)
                    }
                }
                .cornerRadius(12, corners: [.topLeft, .topRight])
                .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isPresented)
                .transition(.move(edge: .bottom))
            }
        }
    }
}

// 扩展：为指定的角添加圆角
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

// 扩展：简化圆角设置
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}
