## AI开发关键词

### v1.0版本(底部导航栏)

```
在SwiperIOS/Content/ContentView中搭建框架
 -框架组成：分上下两部分(底部导航栏和内容区)；底部导航栏 位于底部且平分5部分，内容区域占据剩余全部
 -适配：全屏沉浸模式
 -底部导航栏：由5部分组成且平分，
  1-首页(标签文字显示)，页面位于SwiperIOS/Content/ContentView/Home下
  2-图集(标签文字显示)，页面位于SwiperIOS/Content/ContentView/Album下
  3-发布(图片(圆圈加号)，页面位于SwiperIOS/Content/ContentView/Publish下
   点击后弹窗，弹窗从底部弹出，位于界面底部布局，几个选项：1-从相册选择，2-相机，3-写文字，4-取消(与上面有间隔)，每个单独一行
发布弹窗，左上角和右上角有椭圆形弧度，从相册选择/相机/写文字，之间有一条分割线，且点击其中任何一项，弹窗消失
  4-消息(标签文字显示，有消息时显示红点，没有时不显示)，页面位于SwiperIOS/Content/ContentView/Message下
  5-我(标签文字显示),页面位于SwiperIOS/Content/ContentView/Me下
  
 -底部导航切换仿照小红书，点击切换时有缩放效果，默认为首页选中(黑色，1.2倍放大)，切换其他按钮时，其他按钮选中(字体颜色由灰色变为黑色，且有1.2缩放效果)；首页由选中变为未选中(字体由黑色变为灰色，字体大小改为原来大小)
 
 - 弹窗组件页面抽取到：SwiperIOS/Content/view/下
 - 底部导航TabBar组件也抽取到：SwiperIOS/Content/view/下
 底部导航：1-首页(显示文字，不显示图标)；2-图集(显示文字，不显示图标)；3-发布(只显示图标)
；4-消息(显示文字，不显示图标)；5-我(显示文字，不显示图标) 
-消息红点与文字间隔太大，位于消息右上角
-底部导航中发布图标，灰色填充蓝色或红色
上步操作有误，不是中间的十字而是圆圈内填充颜色
中间发布按钮圆填充颜色007AFF，中间的+号填充白色；发布按钮高度约等于其他导航栏标签(文字+图标)效果(虽然没有图标)，垂直方向上剧中对其
底部导航栏标签选中时的文字是未选中时的1.5倍
1.5倍有点大，修改成1.35倍吧
底部导航标签未选中文字大小调大一些，12pt调整为13pt
状态栏未显示，沉浸模式下也显示
弹窗中间隔线的颜色为F2F2F2
弹窗最上面的2个分割线透明度0.4
弹窗最上面的2个分割线高度从0.5修改为1
```

### v2.0版本(网络访问框架)

```
基于最流行的网络访问框架Alamofire进行封装
1、网络请求封装
 -封装目录：SwiperIOS/api目录下
 -baseurl为：https://api.apiopen.top/
 -支持Get、Post等请求
 -支持参数编码和自定义请求头
2、错误处理
-错误枚举：错误类型
3、请求结果：
- 使用AlamofireObjectMapper进行扩展
- 将JSON数据转换为swift对象
- 请求结果封装到：SwiperIOS/api/bean目录下
- 我已写了一个bean示例：VideoData，其他参考此示例
4、真实请求：
- 封装到：SwiperIOS/api/APIService.swift文件下
- 基于SwiperIOS/api/APIClient.swift封装实现功能
- 执行网络请求结果为bean目录下对应实体类(参考VideoData)
- 失败和成功返回结果：参考VideoData
- APIService支持尾随闭包，在页面中调用时直接请求返回结果
- Home.swift页面调用APIService.swift执行真实请求


APIService.swift中添加获取图片列表接口，接口在baseurl后拼接api/images，参数同getVideoList中2个参数，返回结果为ImageData，在Album页面中调用接口测试真实请求

底部导航栏设置颜色，区分内容页面
```

### v3.0 MVC框架改MVVM框架

```
项目框架修改(MVC到MVVM)
1. 修改前(如Home.swift与Album.swift)：逻辑与界面都在一个页面中，混乱且不利于维护
2.修改后：
 - Home与Album文件夹下新增vidwmodel文件夹存放对应的viewmodel(如HomeViewModel与AlbumViewModel)
 - Viewmodel中处理逻辑：如@State修饰的变量与网络请求
 - 页面(如Home.swift与Album.swift)中调用viewmodel并显示界面
 - 自定义页面：自定义界面(如ImageRow或VideoRow)，存放到对应的文件夹/view目录下(如Home/view/VideoRow.swift)
```

