import SwiftUI
 
struct AlbumWaterfallView: View {
    let vm: ImageListViewModel
    let availableWidth: CGFloat
    let onItemTap: (ImageInfo) -> Void
    
    var body: some View {
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
                    let colWidth = (availableWidth - totalPadding) / 2
                    
                    HStack(alignment: .top, spacing: spacing) {
                        VStack(spacing: spacing) {
                            ForEach(vm.images.enumerated().filter { $0.offset % 2 == 0 }.map { $0.element }, id: \.id) { img in
                                WaterfallImageItem(image: img, width: colWidth, onTap: onItemTap)
                            }
                        }
                        VStack(spacing: spacing) {
                            ForEach(vm.images.enumerated().filter { $0.offset % 2 == 1 }.map { $0.element }, id: \.id) { img in
                                WaterfallImageItem(image: img, width: colWidth, onTap: onItemTap)
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
}
