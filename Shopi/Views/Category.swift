
import SwiftUI

struct Category: View {
    @EnvironmentObject var store: Store
    
    @Binding var showingSearchBar: Bool
    
    @State private var edge = UIApplication.shared.windows.first?.safeAreaInsets
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(store.categories, id: \.self) { item in
                    CategoryItem(image: item.lowercased(), name: item)
                }
            }
            .offset(y: showingSearchBar ? 55 : 0)
            .padding(.horizontal, 10)
            .padding(.top, (110 - edge!.top) + 20)
            .padding(.bottom, 110 + 40)
        }
    }
}


struct CategoryItem: View {
    var image: String
    var name: String
    
    var body: some View {
        ZStack {
            Color("FontColor")
            
            VStack {
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 160)
                    .cornerRadius(20)
                
                Text(name)
                    .font(.headline)
                    .padding(.bottom, 8)
                    .foregroundColor(Color.white)
            }
        }
        .frame(width: 160, height: 180)
        .cornerRadius(20)
        .shadow(color: Color("IconColor").opacity(0.1), radius: 5, x: 5, y: 5)
        .shadow(color: Color.white.opacity(1), radius: 5, x: -5, y: -5)
        .buttonStyle(SinkInButtonStyle())
        .animation(.easeInOut(duration: 0.2))
    }
}





struct Category_Previews: PreviewProvider {
    static var previews: some View {
        Category(showingSearchBar: .constant(false))
    }
}
