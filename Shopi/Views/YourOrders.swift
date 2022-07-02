
import SwiftUI

struct YourOrders: View {
    @EnvironmentObject var userStore: UserStore
    
    @Binding var showingSearchBar: Bool
    
    @State private var edge = UIApplication.shared.windows.first?.safeAreaInsets
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 40) {
                if !userStore.arrivingOrdersList.isEmpty || !userStore.orderHistoryList.isEmpty {
                    if !userStore.arrivingOrdersList.isEmpty {
                        ArrvingOrders()
                    } else {
                        Text("You have no recent orders.")
                            .font(.headline)
                            .foregroundColor(Color("FontColor").opacity(0.6))
                    }
                    
                    if !userStore.orderHistoryList.isEmpty {
                        OrderHistory()
                    }
                } else {
                    Text("You haven't place any order yet.")
                        .font(.headline)
                        .foregroundColor(Color("FontColor").opacity(0.6))
                }
            }
            .offset(y: showingSearchBar ? 55 : 0)
            .padding(.top, (110 - edge!.top) + 20)
            .padding(.bottom, 110 + 40)
            .animation(.easeInOut)
        }
    }
}


struct ArrvingOrders: View {
    @EnvironmentObject var userStore: UserStore
    
    @State private var index: Int = 0
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Text("Arriving Orders")
                    .font(.headline)
                    .foregroundColor(Color("FontColor"))
                    .padding(.leading, 30)
                
                Spacer()
            }
            
            VStack(spacing: 0) {
                ForEach(userStore.arrivingOrdersList) { order in
                    OrderLayout(order: order)
                        .transition(.scale)
                        .onAppear { index += 1 }
                    
                    Rectangle()
                        .frame(width: screen.width * 0.8, height: 1)
                        .foregroundColor(Color(.systemGray4))
                        .transition(.scale)
                }
            }
        }.frame(width: screen.width)
    }
}


struct OrderHistory: View {
    @EnvironmentObject var userStore: UserStore
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Text("Orders History")
                    .font(.headline)
                    .foregroundColor(Color("FontColor"))
                    .padding(.leading, 30)
                
                Spacer()
            }
            
            VStack(spacing: 0) {
                ForEach(userStore.orderHistoryList) { order in
                    OrderLayout(order: order)
                        .transition(.scale)
                    
                    Rectangle()
                        .frame(width: screen.width * 0.8, height: 1)
                        .foregroundColor(Color(.systemGray4))
                        .transition(.scale)
                }
            }
        }
    }
}


struct OrderLayout: View {
    var order: ItemModel
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Image(order.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 120)
                    .clipShape(Rectangle())
                    .cornerRadius(20)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(order.name)
                        .font(.headline)
                    
                    HStack {
                        Text("$\(order.price, specifier: "%.2f")")
                        
                        Spacer()
                        
                        HStack {
                            Text("Qty:").bold()
                            
                            Text("\(order.quantity)")
                        }
                        .padding(.trailing, 10)
                    }
                }
                .font(.subheadline)
                .foregroundColor(Color("FontColor"))
            }
            .frame(width: screen.width * 0.85)
            
            Text("Delivering tomorrow by 9 am")
                .font(.system(.subheadline, design: .rounded))
                .foregroundColor(Color.black.opacity(0.6))
        }
        .frame(width: screen.width * 0.85, height: 130)
        .padding(.top, 10)
        .padding(.horizontal, 15)
        .padding(.bottom, 20)
    }
}





//struct YourOrders_Previews: PreviewProvider {
//    static var previews: some View {
//        YourOrders(showingSearchBar: .constant(false))
//    }
//}
