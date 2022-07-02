
import SwiftUI

struct Home: View {
    @Binding var showCartAlert: Bool
    @Binding var showingSearchBar: Bool
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 30) {
                PopularCat()

                Ads()
                
                LatestArrival(showCartAlert: $showCartAlert)
            }
            .offset(y: showingSearchBar ? 55 : 0)
            .padding(.top, (95 - edge!.top) + 25)
            .padding(.bottom, 110 + 50)
        }
    }
}


struct PopularCat: View {
    @State var selected = 0
    
    let popularCat: [String] = ["Fashion", "Electronics", "Sports", "Kitchen", "Grocery", "Books", "Toys"]
    

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Popular")
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(Color("FontColor"))
                .padding(.leading, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 30) {
                    ForEach(popularCat, id: \.self) { item in
                        Button(action: {}) {
                            PopularCatItem(image: item.lowercased(), name: item)
                        }.buttonStyle(SinkInButtonStyle())
                    }
                }
                .padding(.horizontal, 20)
                .frame(height: 100)
            }
        }
        .animation(.easeInOut(duration: 0.2))
    }
}


struct PopularCatItem: View {
    var image: String
    var name: String
    
    var body: some View {
        VStack {
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 60, height: 60)
                .clipShape(Circle())
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 5, y: 5)
                .shadow(color: Color.white.opacity(1), radius: 5, x: -5, y: -5)
            
            Text(name)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(Color("FontColor"))
        }
    }
}


struct Ads: View {
    var body: some View {
        TabView {
            SamsungNote20()
            
            MacBookPro()
            
            Sony()
            
            ClothingSale()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 250)
        .tabViewStyle(PageTabViewStyle())
        .animation(.easeInOut(duration: 0.2))
    }
}


struct SamsungNote20: View {
    var body: some View {
        ZStack(alignment: .topLeading) {
            Image("note20")
                .resizable()
                .aspectRatio(contentMode: .fill)
            
            Color.white.opacity(0.15)
            
            VStack(alignment: .leading) {
                HStack {
                    Image("samsung")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100)
                    
                    Text("Note 20 Ultra")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .offset(y: -3)
                }
                
                Text("5G Ready.")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Pre-order now" + "\nBenifits up to $250")
                    .font(.title3)
                    .foregroundColor(.white)
                    .frame(height: 70)
                
                Spacer()
                
                Text("*T&C apply.")
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(.bottom, 5)
            }
            .padding([.leading, .top, .bottom], 25)
        }
    }
}


struct MacBookPro: View {
    var body: some View {
        ZStack {
            Color.white
            
            Image("macbookAd")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: screen.width)
        }
    }
}


struct Sony: View {
    var body: some View {
        ZStack(alignment: .topLeading) {
            HStack {
                Spacer()
                
                Image("wh1000xm4")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            
            Color.white.opacity(0.2)
            
            VStack(alignment: .leading) {
                HStack {
                    Image("sony")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100)
                    
                    Text("WH-1000XM4")
                        .font(.title2)
                        .fontWeight(.bold)
                        .fontWeight(.regular)
                        .foregroundColor(.black)
                }
                
                Text("Noise-Cancelling Headphones")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                Text("$349.99")
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.black)
                    .frame(height: 70)
            }
            .padding()
        }
        .background(Color.white)
    }
}


struct ClothingSale: View {
    var body: some View {
        ZStack(alignment: .topLeading) {
            Image("clothingsale")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: screen.width)
            
            VStack(spacing: 15) {
                Text("Clothing Sale")
                    .font(.largeTitle)
                    .bold()
                
                Text("Upto 75% Off.")
                    .font(.title3)
            }
            .padding(.leading, 10)
            .padding(.top, 60)
        }
    }
}


struct LatestArrival: View {
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var store: Store
    
    @Binding var showCartAlert: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Latest Arrivals")
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(Color("FontColor"))
                .padding(.leading, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 30) {
                    ForEach(store.latestArrivalList) { item in
                        VStack(alignment: .leading, spacing: 15) {
                            Image(item.image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 250, height: 250)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                            
                            HStack {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(item.name)
                                        .font(.headline)
                                    
                                    Text("$\(item.price, specifier: "%.2f")")
                                        .font(.subheadline)
                                }
                                
                                Spacer()
                                
                                Button(action: {
                                    withAnimation {
                                        impact(style: .medium)
                                        userStore.AddToCart(
                                            CartModel(
                                                id: item.id,
                                                name: item.name,
                                                category: item.category,
                                                image: item.image,
                                                price: item.price,
                                                quantity: item.quantity
                                            )
                                        )
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                            showCartAlert = true
                                            haptic(type: .success)
                                            
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { showCartAlert = false }
                                        }
                                    }
                                }) {
                                    Image(systemName: "cart.fill.badge.plus")
                                        .font(.title2)
                                }.buttonStyle(SinkInButtonStyle())
                            }
                            .foregroundColor(Color("FontColor"))
                            .padding(.horizontal, 10)
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .animation(.easeInOut(duration: 0.2))
    }
}




//struct Home_Previews: PreviewProvider {
//    static var previews: some View {
//        Home(showCartAlert: .constant(false), showingSearchBar: .constant(false)
//    }
//}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
