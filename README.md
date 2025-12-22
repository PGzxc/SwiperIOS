# SwiperIOS

## 一 说明

* 说明：基于APIOpen接口制作仿抖音IOS版
* 接口地址：https://api.apiopen.top/
* 实现功能：放抖音/某红书
* 功能模块：首页、图集、发布、消息、我

## 二 开发环境

* 系统：MacOS Sequoia 15.7.3
* IDE：Xcode(26.2)
* Expo SDK：54
* Node: 22.12.0
* Npm: 11.6.4
* AI助手：Trae

## 三 效果预览

## 四 开发阶段

### v1.0 底部导航栏框架(2025.12.14)

* 仿抖音/小红书底部导航栏切换
* 导航栏：1-首页；2-图集；3-发布；4-消息；5-我；
* 弹窗：点击发布弹窗；1-从相册选择；2-相机；3-写文字；4-取消；

### v2.0 网络访问框架(2025.12.16)

* 网络框架搭建：alamofire+ObjectMapper
* 网络抽象层：APIClient(传入参数后，执行请求)
* 真正请求：APIService：基于APIClient执行请求，尾随闭包
* 执行请求后显示：Home(首页)、Album(图集页)

### v3.0 MVC框架改MVVM框架

* 创建ViewModel文件结构

  - 在 Home 文件夹下创建了 viewmodel 文件夹和 HomeViewModel.swift 文件
  - 在 Album 文件夹下创建了 viewmodel 文件夹和 AlbumViewModel.swift 文件
* 实现ViewModel逻辑

  - 将页面中的 @State 变量迁移到ViewModel中作为 @Published 属性
  - 在ViewModel中实现网络请求逻辑，如 loadVideos() 和 loadImages() 方法
  - 使用 ObservableObject 协议使ViewModel可被View观察
* 更新页面文件

  - 在 Home.swift 中使用 @StateObject 引用 HomeViewModel ，并将UI绑定到ViewModel的状态
  - 在 Album.swift 中使用 @StateObject 引用 AlbumViewModel ，并将UI绑定到ViewModel的状态
  - 移除了页面中直接的网络请求和状态管理逻辑
* Home页面(Alb um同)组件提取

  - 在 Home 文件夹下创建了 view 目录
  - 将 VideoRow 从 Home.swift 中提取出来，保存到 Home/view/VideoRow.swift 文件中
  - 从 Home.swift 中移除了 VideoRow 的定义

### v4.0 首页(仿抖音)

* App沉浸式，状态栏透明
* ContentView是Flex布局，除底部TabBar，内容区域为flexGrow(1)
* 顶部标签栏：左搜索+中(同城、关注、推荐)+右加号
* 切换标签栏：1-标签栏切换可滑动/点击；2-分别对应City(同城)、Focus(关注)、Recommend(推荐)
* 标签对应页面：1-视频(平铺页面)；2-右侧操作栏；3-底部视频信息栏

## 五 效果图

### v1.0 底部导航栏框架-效果图

| ![][v1-1] | ![][v1-2] | ![][v1-3] |
| :-------: | :-------: | :-------: |
| ![][v1-4] | ![][v1-5] |           |

### v2.0 网络框架-效果图

| ![][v2-1] | ![][v2-2] |
| :-------: | :-------: |
| ![][v2-3] |           |

### v4.0 首页(仿抖音)-效果图

| ![][v4-1] | ![][v4-2] | ![][v4-3] |
| :-------: | :-------: | :-------: |
| ![][v4-4] | ![][v4-5] |           |



[v1-1]:resources/v1/v1-1-home.png
[v1-2]:resources/v1/v1-2-album.png
[v1-3]:resources/v1/v1-3-pub.png
[v1-4]:resources/v1/v1-4-msg.png
[v1-5]:resources/v1/v1-5-me.png

[v2-1]:resources/v2/v2-1-home.png
[v2-2]:resources/v2/v2-2-album.png
[v2-3]:resources/v2/v2-3-pub.png

[v4-1]:resources/v4/v4-1-home-load.png
[v4-2]:resources/v4/v4-2-home-play.png
[v4-3]:resources/v4/v4-3-home-state.png
[v4-4]:resources/v4/v4-4-focus-state.png
[v4-5]:resources/v4/v4-5-home-city.png