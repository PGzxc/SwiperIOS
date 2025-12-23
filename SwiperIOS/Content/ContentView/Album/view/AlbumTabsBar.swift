import SwiftUI
 
struct AlbumTabsBar: View {
    @Binding var selected: ImageListViewModel.Category
    
    var body: some View {
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
    }
}
