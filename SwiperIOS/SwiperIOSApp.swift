//
//  SwiperIOSApp.swift
//  SwiperIOS
//
//  Created by xc z on 2025/12/13.
//

import SwiftUI

@main
struct SwiperIOSApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark) // 强制深色模式，确保状态栏文字为白色
        }
    }
}
