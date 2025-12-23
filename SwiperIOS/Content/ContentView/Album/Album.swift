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
                    AlbumTabsBar(selected: $selected)
                        .padding(.top, max(proxy.safeAreaInsets.top, 47))
                    
                Spacer().frame(height: 10)
                
                TabView(selection: $selected) {
                    AlbumWaterfallView(vm: vmAnimal, availableWidth: proxy.size.width) { tapped in
                        fullscreenImage = tapped
                        zoomScale = 1.0
                    }
                    .tag(ImageListViewModel.Category.animal)
                    AlbumWaterfallView(vm: vmBeauty, availableWidth: proxy.size.width) { tapped in
                        fullscreenImage = tapped
                        zoomScale = 1.0
                    }
                    .tag(ImageListViewModel.Category.beauty)
                    AlbumWaterfallView(vm: vmCar, availableWidth: proxy.size.width) { tapped in
                        fullscreenImage = tapped
                        zoomScale = 1.0
                    }
                    .tag(ImageListViewModel.Category.car)
                    AlbumWaterfallView(vm: vmComic, availableWidth: proxy.size.width) { tapped in
                        fullscreenImage = tapped
                        zoomScale = 1.0
                    }
                    .tag(ImageListViewModel.Category.comic)
                    AlbumWaterfallView(vm: vmFood, availableWidth: proxy.size.width) { tapped in
                        fullscreenImage = tapped
                        zoomScale = 1.0
                    }
                    .tag(ImageListViewModel.Category.food)
                    AlbumWaterfallView(vm: vmGame, availableWidth: proxy.size.width) { tapped in
                        fullscreenImage = tapped
                        zoomScale = 1.0
                    }
                    .tag(ImageListViewModel.Category.game)
                    AlbumWaterfallView(vm: vmMovie, availableWidth: proxy.size.width) { tapped in
                        fullscreenImage = tapped
                        zoomScale = 1.0
                    }
                    .tag(ImageListViewModel.Category.movie)
                    AlbumWaterfallView(vm: vmPerson, availableWidth: proxy.size.width) { tapped in
                        fullscreenImage = tapped
                        zoomScale = 1.0
                    }
                    .tag(ImageListViewModel.Category.person)
                    AlbumWaterfallView(vm: vmPhone, availableWidth: proxy.size.width) { tapped in
                        fullscreenImage = tapped
                        zoomScale = 1.0
                    }
                    .tag(ImageListViewModel.Category.phone)
                    AlbumWaterfallView(vm: vmScenery, availableWidth: proxy.size.width) { tapped in
                        fullscreenImage = tapped
                        zoomScale = 1.0
                    }
                    .tag(ImageListViewModel.Category.scenery)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
                
                if let img = fullscreenImage {
                    FullscreenImageOverlay(image: img, zoomScale: $zoomScale) {
                        fullscreenImage = nil
                        zoomScale = 1.0
                    }
                }
            }
        }
        .onAppear { vm(for: selected).loadIfNeeded() }
        .onChange(of: selected) { newCat in
            vm(for: newCat).loadIfNeeded()
        }
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
