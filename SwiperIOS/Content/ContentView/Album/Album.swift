import SwiftUI
import Combine
 
struct AlbumView: View {
    @State private var selected: ImageListViewModel.Category = .animal
    @StateObject private var vmAnimal = ImageListViewModel(category: .animal)
    @StateObject private var vmBeauty = ImageListViewModel(category: .beauty)
    @StateObject private var vmCar = ImageListViewModel(category: .car)
    @StateObject private var vmComic = ImageListViewModel(category: .comic)
    @StateObject private var vmFood = ImageListViewModel(category: .food)
    @StateObject private var vmGame = ImageListViewModel(category: .game)
    @StateObject private var vmMovie = ImageListViewModel(category: .movie)
    @StateObject private var vmPerson = ImageListViewModel(category: .person)
    @StateObject private var vmPhone = ImageListViewModel(category: .phone)
    @StateObject private var vmScenery = ImageListViewModel(category: .scenery)
    @State private var fullscreenImage: ImageInfo? = nil
    @State private var zoomScale: CGFloat = 1.0
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                VStack(spacing: 0) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(ImageListViewModel.Category.allCases, id: \.self) { cat in
                                Text(cat.title)
                                    .font(.system(size: selected == cat ? 16 : 15, weight: selected == cat ? .bold : .medium))
                                    .foregroundColor(selected == cat ? .white : Color.white.opacity(0.6))
                                    .onTapGesture { withAnimation { selected = cat } }
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                    .padding(.top, max(proxy.safeAreaInsets.top, 47))
                    
                    Spacer().frame(height: 10)
                    
                    TabView(selection: $selected) {
                        waterfall(vmAnimal, proxy: proxy).tag(ImageListViewModel.Category.animal)
                        waterfall(vmBeauty, proxy: proxy).tag(ImageListViewModel.Category.beauty)
                        waterfall(vmCar, proxy: proxy).tag(ImageListViewModel.Category.car)
                        waterfall(vmComic, proxy: proxy).tag(ImageListViewModel.Category.comic)
                        waterfall(vmFood, proxy: proxy).tag(ImageListViewModel.Category.food)
                        waterfall(vmGame, proxy: proxy).tag(ImageListViewModel.Category.game)
                        waterfall(vmMovie, proxy: proxy).tag(ImageListViewModel.Category.movie)
                        waterfall(vmPerson, proxy: proxy).tag(ImageListViewModel.Category.person)
                        waterfall(vmPhone, proxy: proxy).tag(ImageListViewModel.Category.phone)
                        waterfall(vmScenery, proxy: proxy).tag(ImageListViewModel.Category.scenery)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                }
                
                if let img = fullscreenImage {
                    let urlString = img.fileName.flatMap { "https://api.apiopen.top/api/files/\($0)" }
                    ZStack {
                        Color.black.opacity(0.6)
                            .ignoresSafeArea()
                            .contentShape(Rectangle())
                            .onTapGesture {
                                fullscreenImage = nil
                                zoomScale = 1.0
                            }
                        if let urlStr = urlString, let url = URL(string: urlStr) {
                            AsyncImage(url: url) { i in
                                i.resizable().scaledToFit()
                            } placeholder: {
                                ProgressView()
                            }
                            .scaleEffect(zoomScale)
                            .gesture(
                                MagnificationGesture()
                                    .onChanged { value in
                                        let v = max(1.0, min(value, 4.0))
                                        zoomScale = v
                                    }
                            )
                            .onTapGesture {
                                fullscreenImage = nil
                                zoomScale = 1.0
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else {
                            Color.black.opacity(0.6).onTapGesture {
                                fullscreenImage = nil
                                zoomScale = 1.0
                            }
                        }
                    }
                    .transition(.opacity)
                }
            }
        }
        .onAppear { vm(for: selected).loadIfNeeded() }
        .onChange(of: selected) { newCat in
            vm(for: newCat).loadIfNeeded()
        }
    }
    
    @ViewBuilder
    private func waterfall(_ vm: ImageListViewModel, proxy: GeometryProxy) -> some View {
        ZStack {
            if vm.images.isEmpty {
                if vm.isLoading {
                    ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else if let err = vm.errorMessage {
                    Text(err).foregroundColor(.white)
                } else {
                    Color.black
                }
            } else {
                ScrollView {
                    let spacing: CGFloat = 8
                    let totalPadding: CGFloat = 16 * 2 + spacing
                    let colWidth = (proxy.size.width - totalPadding) / 2
                    
                    HStack(alignment: .top, spacing: spacing) {
                        VStack(spacing: spacing) {
                            ForEach(vm.images.enumerated().filter { $0.offset % 2 == 0 }.map { $0.element }, id: \.id) { img in
                                waterfallItem(img, width: colWidth) { tapped in
                                    fullscreenImage = tapped
                                    zoomScale = 1.0
                                }
                            }
                        }
                        VStack(spacing: spacing) {
                            ForEach(vm.images.enumerated().filter { $0.offset % 2 == 1 }.map { $0.element }, id: \.id) { img in
                                waterfallItem(img, width: colWidth) { tapped in
                                    fullscreenImage = tapped
                                    zoomScale = 1.0
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 0)
                    .padding(.bottom, 24)
                }
                .background(Color.black)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .onAppear { vm.loadIfNeeded() }
    }
    
    @ViewBuilder
    private func waterfallItem(_ image: ImageInfo, width: CGFloat, onTap: @escaping (ImageInfo) -> Void) -> some View {
        let height = width * 2
        let urlString = image.fileName.flatMap { "https://api.apiopen.top/api/files/\($0)" }
        ZStack(alignment: .bottom) {
            if let urlStr = urlString, let url = URL(string: urlStr) {
                AsyncImage(url: url) { img in
                    img.resizable().scaledToFill()
                } placeholder: {
                    Color.gray.opacity(0.2)
                }
                .frame(width: width, height: height)
                .clipped()
                .cornerRadius(8)
                .onTapGesture { onTap(image) }
            } else {
                Color.gray.opacity(0.2)
                    .frame(width: width, height: height)
                    .cornerRadius(8)
                    .onTapGesture { onTap(image) }
            }
            VStack(spacing: 6) {
                HStack {
                    Text(image.originalName ?? image.fileName ?? "")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.white)
                        .lineLimit(1)
                    Spacer()
                }
                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 13))
                            .foregroundColor(.white)
                        Text(formatCount(image.likesCont ?? stableCount(image.fileName ?? "\(image.id ?? 0)", max: 1000)))
                            .font(.system(size: 12))
                            .foregroundColor(.white)
                    }
                    Spacer()
                    HStack(spacing: 4) {
                        Image(systemName: "ellipsis.bubble.fill")
                            .font(.system(size: 13))
                            .foregroundColor(.white)
                        Text(formatCount(image.commentsCont ?? stableCount((image.originalName ?? image.fileName ?? "\(image.id ?? 0)") + "c", max: 1000)))
                            .font(.system(size: 12))
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 8)
            .frame(width: width, alignment: .bottom)
            .background(Color.black.opacity(0.6))
        }
    }
    
    private func formatCount(_ count: Int) -> String {
        if count >= 10_000 {
            return String(format: "%.1fw", Double(count) / 10_000.0)
        }
        return "\(count)"
    }
    
    private func stableCount(_ seed: String, max: Int) -> Int {
        let v = abs(seed.hashValue % max)
        return (v == 0) ? 1 : v
    }
    
    private func vm(for category: ImageListViewModel.Category) -> ImageListViewModel {
        switch category {
        case .animal: return vmAnimal
        case .beauty: return vmBeauty
        case .car: return vmCar
        case .comic: return vmComic
        case .food: return vmFood
        case .game: return vmGame
        case .movie: return vmMovie
        case .person: return vmPerson
        case .phone: return vmPhone
        case .scenery: return vmScenery
        }
    }
}
 
#Preview {
    AlbumView()
        .preferredColorScheme(.dark)
}
