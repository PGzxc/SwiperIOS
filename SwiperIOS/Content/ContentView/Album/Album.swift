import SwiftUI
import ObjectMapper
import Alamofire
import Combine

struct AlbumView: View {
    @StateObject private var viewModel = AlbumViewModel()
    
    var body: some View {
        ZStack {
            Color.white
            
            if viewModel.isLoading {
                ProgressView("加载中...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .font(.title3)
                    .foregroundStyle(.black)
            } else if let error = viewModel.errorMessage {
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
                    Button(action: viewModel.loadImages) {
                        Text("重试")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                }
            } else {
                List(viewModel.images, id: \.id) { image in
                    ImageRow(image: image)
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("图集")
        .onAppear {
            viewModel.loadImages()
        }
    }
}

#Preview {
    AlbumView()
}