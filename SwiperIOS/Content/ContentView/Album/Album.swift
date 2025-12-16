import SwiftUI
import ObjectMapper
import Alamofire

struct AlbumView: View {
    @State private var images: [ImageInfo] = []
    @State private var isLoading: Bool = false
    @State private var errorMessage: String? = nil
    @State private var page: Int = 1
    @State private var size: Int = 10
    
    var body: some View {
        ZStack {
            Color.white
            
            if isLoading {
                ProgressView("加载中...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .font(.title3)
                    .foregroundStyle(.black)
            } else if let error = errorMessage {
                VStack {
                    Text("加载失败")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.red)
                        .padding()
                    Text(error)
                        .font(.body)
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.center)
                        .padding()
                    Button(action: loadImages) {
                        Text("重试")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                }
            } else {
                List(images, id: \.id) { image in
                    ImageRow(image: image)
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("图集")
        .onAppear {
            loadImages()
        }
    }
    
    private func loadImages() {
        isLoading = true
        errorMessage = nil
        
        // 使用APIService请求图片列表
        APIService.shared.getImageList(
            page: page,
            size: size
        ) { (result: Result<APIResponse<[ImageInfo]>, APIError>) in
            DispatchQueue.main.async {
                self.isLoading = false
                
                switch result {
                case .success(let response):
                    print("APIService Image Response:")
                    print("Code: \(response.code ?? -1)")
                    print("Message: \(response.message ?? String())")
                    print("Data: \(String(describing: response.data))")
                    print("Total: \(response.total ?? 0)")
                    
                    if let imageList = response.data {
                        self.images = imageList
                        print("Image count: \(imageList.count)")
                    } else {
                        self.errorMessage = "没有找到图片数据"
                    }
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    print("APIService Image Error: \(error)")
                }
            }
        }
    }
}

struct ImageRow: View {
    let image: ImageInfo
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let fileName = image.fileName {
                AsyncImage(url: URL(string: "https://api.apiopen.top/api/files/\(fileName)")) {
                    phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 100, height: 100)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                            .cornerRadius(8)
                    case .failure:
                        Image(systemName: "photo")
                            .frame(width: 100, height: 100)
                            .foregroundStyle(.gray)
                    @unknown default:
                        Text("未知状态")
                    }
                }
            }
            
            if let originalName = image.originalName {
                Text(originalName)
                    .font(.headline)
                    .foregroundStyle(.black)
                    .lineLimit(2)
            }
            
            if let uploader = image.uploader?.nickname {
                Text("上传者: \(uploader)")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
            
            if let uploadTime = image.uploadTime {
                Text("上传时间: \(uploadTime)")
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            
            HStack(spacing: 16) {
                if let comments = image.commentsCont {
                    Text("评论: \(comments)")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
                
                if let likes = image.likesCont {
                    Text("点赞: \(likes)")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
                
                if let shares = image.sharesCont {
                    Text("分享: \(shares)")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    AlbumView()
}