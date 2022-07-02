
import SwiftUI

struct Cart: View {
    @EnvironmentObject var userStore: UserStore
    
    @Binding var showPurchaseAlert: Bool
    @Binding var showingSearchBar: Bool
    
    @State private var edge = UIApplication.shared.windows.first?.safeAreaInsets
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 40) {
                CheckOutButton(showPurchaseAlert: $showPurchaseAlert)
                
                if !userStore.cartItems.isEmpty || !userStore.savedForLaterItems.isEmpty {
                    if !userStore.cartItems.isEmpty {
                        VStack(spacing: 0) {
                            ForEach(userStore.cartItems) { item in
                                CartItem(
                                    item: CartModel(
                                        id: item.id,
                                        name: item.name,
                                        category: item.category,
                                        image: item.image,
                                        price: item.price,
                                        quantity: item.quantity
                                    )
                                )
                                .transition(.scale)
                                
                                Rectangle()
                                    .frame(width: screen.width * 0.8, height: 1)
                                    .foregroundColor(Color(.systemGray4))
                                    .transition(.scale)
                            }
                        }
                    } else {
                        Text("Your Cart is empty.")
                            .font(.headline)
                            .foregroundColor(Color("FontColor").opacity(0.6))
                            .transition(.scale)
                    }
                    
                    if !userStore.savedForLaterItems.isEmpty {
                        VStack(spacing: 0) {
                            HStack {
                                Text("Saved for later")
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                                    .foregroundColor(Color("FontColor"))
                                    .padding(.leading, 30)
                                
                                Spacer()
                            }
                            .transition(.scale)
                            
                            VStack(spacing: 0) {
                                ForEach(userStore.savedForLaterItems) { item in
                                    SavedForLater(
                                        item: CartModel(
                                            id: item.id,
                                            name: item.name,
                                            category: item.category,
                                            image: item.image,
                                            price: item.price,
                                            quantity: item.quantity
                                        )
                                    )
                                    .transition(.scale)
                                    
                                    Rectangle()
                                        .frame(width: screen.width * 0.8, height: 1)
                                        .foregroundColor(Color(.systemGray4))
                                        .transition(.scale)
                                    
                                }
                            }
                        }
                    }
                } else {
                    Text("Your Shopping Cart is empty.")
                        .font(.headline)
                        .foregroundColor(Color("FontColor").opacity(0.6))
                        .transition(.scale)
                }
            }
            .offset(y: showingSearchBar ? 55 : 0)
            .padding(.top, (110 - edge!.top) + 20)
            .padding(.bottom, 110 + 40)
        }
    }
}


struct CheckOutButton: View {
    @EnvironmentObject var userStore: UserStore
    @Binding var showPurchaseAlert: Bool
    
    @State private var disable: Bool = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("Total:")
                    .font(.title3)
                
                Text("$\(userStore.CartTotalAmount(), specifier: "%.2f")")
                    .font(.title2)
                    .bold()
            }
            .foregroundColor(Color("FontColor"))
            
            Spacer()
            
            Button(action: {
                disable = true
                withAnimation {
                    impact(style: .heavy)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        showPurchaseAlert = true
                        disable = false
                        userStore.PlaceOrder()
                        haptic(type: .success)
                    }
                }
            }) {
                Text("Proceed")
                    .font(.headline)
                    .foregroundColor(Color("FontColor"))
                    .padding(12)
                    .background(Color("ThemeColor"))
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 5, y: 5)
                    .shadow(color: Color.white.opacity(1), radius: 5, x: -5, y: -5)
                    .animation(.none)
            }
            .buttonStyle(SinkInButtonStyle())
            .opacity(userStore.CartTotalAmount() == 0 || disable  ? 0.6 : 1)
            .disabled(userStore.CartTotalAmount() == 0 || disable ? true : false)
        }
        .padding(.horizontal, 15)
        .animation(.easeInOut(duration: 0.2))
    }
}


struct CartItem: View {
    @EnvironmentObject var userStore: UserStore
    
    var  item: CartModel
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Image(item.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 100)
                    .clipShape(Rectangle())
                    .cornerRadius(20)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(item.name)
                        .font(.headline)
                    
                    HStack(spacing: 4) {
                        Text("$\(item.price, specifier: "%.2f")")
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(Color(.systemOrange))
                        
                        Spacer()
                        
                        Group {
                            Image(systemName: "minus.circle")
                                .font(.title3)
                                .opacity(0.9)
                                .onTapGesture{
                                    userStore.ChangeQuantity(of: item, action: .decrease)
                                }
                            
                            Text("\(item.quantity)")
                                .foregroundColor(Color(.systemOrange))
                                .frame(width: 20)
                                .animation(.none)
                            
                            Image(systemName: "plus.circle")
                                .font(.title3)
                                .opacity(0.9)
                                .onTapGesture{
                                    userStore.ChangeQuantity(of: item, action: .increase)
                                }
                        }
                    }
                }
                .foregroundColor(Color("FontColor"))
            }
            .frame(width: screen.width * 0.85)
            
            HStack {
                Button(action: {
                    withAnimation {
                        userStore.RemoveFromCart(item)
                    }
                }) {
                    Text("Delete")
                        .font(.subheadline)
                        .bold()
                        .padding(.vertical, 5)
                        .padding(.horizontal, 12)
                        .background(
                            Capsule().foregroundColor(Color(.secondarySystemFill))
                        )
                }
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        userStore.SaveForLater(item)
                        userStore.RemoveFromCart(item)
                    }
                }) {
                    Text("Save for later")
                        .font(.subheadline)
                        .bold()
                        .padding(.vertical, 5)
                        .padding(.horizontal, 12)
                        .background(
                            Capsule().foregroundColor(Color(.secondarySystemFill))
                        )
                }
            }
            .foregroundColor(Color("FontColor"))
            .buttonStyle(SinkInButtonStyle())
            .animation(.easeInOut(duration: 0.2))
        }
        .frame(width: screen.width * 0.85, height: 120)
        .padding([.horizontal, .top], 15)
        .padding(.bottom, 20)
    }
}


struct SavedForLater: View {
    @EnvironmentObject var userStore: UserStore
    
    var item: CartModel
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Image(item.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 100)
                    .clipShape(Rectangle())
                    .cornerRadius(20)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(item.name)
                        .font(.headline)
                    
                    HStack {
                        Text("$\(item.price, specifier: "%.2f")")
                            .foregroundColor(Color(.darkGray))
                        
                        Spacer()
                        
                        HStack {
                            Text("Qty:").bold()
                            
                            Text("\(item.quantity)")
                        }
                        .padding(.trailing, 10)
                    }
                }
                .font(.subheadline)
                .foregroundColor(Color("FontColor"))
            }
            .frame(width: screen.width * 0.85)
            
            Button(action: {
                withAnimation {
                    userStore.AddToCart(item)
                    userStore.RemoveFromSaved(item)
                }
            }) {
                Text("Move to cart")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(Color("FontColor"))
                    .padding(.vertical, 4)
                    .padding(.horizontal, 12)
                    .background(
                        Capsule().foregroundColor(Color(.secondarySystemFill))
                    )
            }
            .buttonStyle(SinkInButtonStyle())
            .animation(.easeInOut(duration: 0.2))

        }
        .frame(width: screen.width * 0.85, height: 130)
        .padding(.top, 10)
        .padding(.horizontal, 15)
        .padding(.bottom, 20)
    }
}





//struct Cart_Previews: PreviewProvider {
//    static var previews: some View {
//        Cart(showPurchaseAlert: .constant(false), showingSearchBar: .constant(false))
//    }
//}
