
import SwiftUI

let screen = UIScreen.main.bounds

let edge = UIApplication.shared.windows.first?.safeAreaInsets

struct MainView: View {
    @EnvironmentObject var user: User
    
    @Binding var showMainView: Bool
    
    @State private var showingSearchBar: Bool = false
    @State private var index = 1
    @State private var expand = false
    @State private var showCartAlert = false
    @State private var showPurchaseAlert = false
    
    var pageName: String {
        if index == 1 {
            return "Home"
        } else if index == 2 {
            return "Category"
        } else if index == 3 {
            return "Your Orders"
        } else if index == 4 {
            return "Cart"
        } else if index == 5 {
            return "Shopi Pay"
        } else if index == 6 {
            return "Account"
        } else if index == 7 {
            return "Settings"
        }
        
        return ""
    }
    
    var body: some View {
        ZStack {
            Color("ThemeColor")
            
            TabView(selection: $index) {
                Home(showCartAlert: $showCartAlert, showingSearchBar: $showingSearchBar)
                    .background(Color("ThemeColor"))
                    .tag(1)
                
                Category(showingSearchBar: $showingSearchBar)
                    .background(Color("ThemeColor"))
                    .tag(2)
                
                YourOrders(showingSearchBar: $showingSearchBar)
                    .background(Color("ThemeColor"))
                    .tag(3)
                
                Cart(showPurchaseAlert: $showPurchaseAlert, showingSearchBar: $showingSearchBar)
                    .background(Color("ThemeColor"))
                    .tag(4)
                
                Account()
                    .background(Color("ThemeColor"))
                    .tag(6)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .overlay(
                showingSearchBar ?
                    Color.black.opacity(0.2)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.all)
                    .transition(.opacity)
                    .onTapGesture {
                        impact(style: .soft)
                        
                        if showingSearchBar == true {
                            hideKeyBoard()
                        }
                        
                        withAnimation(Animation.easeInOut(duration: 0.2)) {
                            showingSearchBar = false
                        }
                    }
                : nil
            )
            .edgesIgnoringSafeArea([.top, .bottom])
            
            VStack {
                HeaderView(showingSearchBar: $showingSearchBar, pageName: pageName)
                
                Spacer()
                
                TabBar(index: $index)
            }
            
            VStack {
                HUDNotification()
                    .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
                    .scaleEffect(showCartAlert ? 1 : 0)
                    .opacity(showCartAlert ? 1 : 0)
                    .offset(y: showCartAlert ? 0 : -100)
                    .animation(.spring(response: 0.35, dampingFraction: 0.6, blendDuration: 0.8))
                    .onTapGesture {
                        index = 4
                        showCartAlert = false
                    }
                Spacer()
            }
            
            if user.isSignOutLoading {
                Color.black.opacity(0.4)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.all)
                    .transition(.opacity)
                
                LoadingView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
        .alert(isPresented: $showPurchaseAlert) {
            Alert(title: Text("Order has been placed"), dismissButton: .default(Text("OK")))
        }
        .onAppear {
            if !user.isLogged {
                withAnimation { showMainView = false }
            }
        }
    }
}


struct HeaderView: View {
    @Binding var showingSearchBar: Bool
    @State private var search = ""
    @State private var searchSelected = false
    
    var pageName: String
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                VStack(spacing: 5) {
                    Text("SHOPI")
                        .font(.system(size: 25, weight: .bold, design: .rounded))
                        .foregroundColor(Color("FontColor"))
                    
                    Text(pageName)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color("FontColor").opacity(0.6))
                        .padding(.bottom, 10)
                }
                .padding(.top, edge?.top)
                
                HStack {
                    Button(action: {  }) {
                        ZStack {
                            Circle()
                                .frame(width: 40, height: 40)
                                .foregroundColor(Color("ThemeColor"))
                                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 5, y: 5)
                                .shadow(color: Color.white.opacity(1), radius: 5, x: -5, y: -5)
                            
                            Image(systemName: "bell")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(Color("FontColor"))
                        }
                    }
                    .buttonStyle(SinkInButtonStyle())
                    .padding(.leading, 25)
                    .animation(.easeInOut(duration: 0.2))
                    
                    Spacer()
                    
                    Button(action: {
                        impact(style: .soft)
                        
                        if showingSearchBar == true {
                            hideKeyBoard()
                        }
                        
                        withAnimation(Animation.easeInOut(duration: 0.2)) {
                            showingSearchBar.toggle()
                        }
                    }) {
                        ZStack {
                            Circle()
                                .frame(width: 40, height: 40)
                                .foregroundColor(Color("ThemeColor"))
                                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 5, y: 5)
                                .shadow(color: Color.white.opacity(1), radius: 5, x: -5, y: -5)
                            
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(Color("FontColor"))
                        }
                    }
                    .buttonStyle(SinkInButtonStyle())
                    .padding(.trailing, 25)
                    .animation(.easeInOut(duration: 0.2))
                }
                .padding(.top, 25)
            }
            
            
            if showingSearchBar {
                SearchBarView(search: $search, searchSelected: $searchSelected)
                    .padding(.bottom, 10)
                    .transition(AnyTransition.offset(y: -20).combined(with: .opacity))
            }
            
        }
        .background(
            RoundedCorner(radius: 30, corners: [.bottomLeft, .bottomRight])
                .foregroundColor(Color("ThemeColor"))
                .shadow(color: Color.black.opacity(0.2), radius: 8)
        )
    }
}


struct TabBar: View {
    @Binding var index: Int
    @State private var showExtendedMenu = false
    @State private var extendedMenuSelected = false
    
    var body: some View {
        ZStack {
            RoundedCorner(radius: 30, corners: [.topLeft, .topRight])
                .frame(width: screen.width, height: 100)
                .foregroundColor(Color("ThemeColor"))
                .shadow(color: Color.black.opacity(0.2), radius: 8)
            
            
            
            HStack {
                Button(action: {
                    impact(style: .light)
                    index = 1
                    extendedMenuSelected = false
                }) {
                    VStack(spacing: 10) {
                        Image(systemName: index == 1 ? "house.fill" : "house")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(index == 1 ? Color("IconColor") : Color("FontColor").opacity(0.5))
                            .offset(y: index == 1 ? 0 : 7)
                        
                        Capsule()
                            .frame(width: 25, height: 4)
                            .foregroundColor(Color("IconColor"))
                            .scaleEffect(index == 1 ? 1 : 0)
                    }
                }
                .padding(.leading, 25)
                .animation(.easeInOut(duration: 0.2))
                
                
                Spacer()
                
                
                Button(action: {
                    impact(style: .light)
                    index = 2
                    extendedMenuSelected = false
                }) {
                    VStack(spacing: 10) {
                        Image(systemName: index == 2 ? "circle.grid.2x2.fill" : "circle.grid.2x2")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(index == 2 ? Color("IconColor") : Color("FontColor").opacity(0.5))
                            .offset(y: index == 2 ? 0 : 7)
                        
                        Capsule()
                            .frame(width: 25, height: 4)
                            .foregroundColor(Color("IconColor"))
                            .scaleEffect(index == 2 ? 1 : 0)
                    }
                }
                .animation(.easeInOut(duration: 0.2))
                
                
                Spacer(minLength: 120)
                
                
                Button(action: {
                    impact(style: .light)
                    index = 3
                    extendedMenuSelected = false
                }) {
                    VStack(spacing: 10) {
                        Image(systemName: index == 3 ? "bag.fill" : "bag")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(index == 3 ? Color("IconColor") : Color("FontColor").opacity(0.5))
                            .offset(y: index == 3 ? 0 : 7)
                        
                        Capsule()
                            .frame(width: 25, height: 4)
                            .foregroundColor(Color("IconColor"))
                            .scaleEffect(index == 3 ? 1 : 0)
                    }
                }
                .animation(.easeInOut(duration: 0.2))
                
                
                Spacer()
                
                
                Button(action: {
                    impact(style: .light)
                    index = 4
                    extendedMenuSelected = false
                }) {
                    VStack(spacing: 10) {
                        Image(systemName: index == 4 ? "cart.fill" : "cart")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(index == 4 ? Color("IconColor") : Color("FontColor").opacity(0.5))
                            .offset(y: index == 4 ? 0 : 7)
                        
                        Capsule()
                            .frame(width: 25, height: 4)
                            .foregroundColor(Color("IconColor"))
                            .scaleEffect(index == 4 ? 1 : 0)
                    }
                }
                .padding(.trailing, 25)
                .animation(.easeInOut(duration: 0.2))
            }
            .buttonStyle(SinkInButtonStyle())
            .disabled(showExtendedMenu ? true : false)
            .blur(radius: showExtendedMenu ? 3 : 0)
            .onTapGesture { withAnimation{ showExtendedMenu = false } }
            
            
            
            ExtendedMenuButton(index: $index, showExtendedMenu: $showExtendedMenu, extendedMenuSelected: $extendedMenuSelected)
        }
        .padding(.bottom, -5)
    }
}

struct ExtendedMenuButton: View {
    @Binding var index: Int
    @Binding var showExtendedMenu: Bool
    @Binding var extendedMenuSelected: Bool
    
    var arrowCondition: Bool {
        return (showExtendedMenu || extendedMenuSelected || index == 5 || index == 6 || index == 7)
    }
    
    var body: some View {
        ZStack {
            FloatingButton(index: $index, showExtendedMenu: $showExtendedMenu, extendedMenuSelected: $extendedMenuSelected)
            
            Button(action: {
                impact(style: .light)
                withAnimation(Animation.timingCurve(0.49, 0.5, 0.34, 0.82)) {
                    showExtendedMenu.toggle()
                }
            }) {
                ZStack {
                    Circle()
                        .frame(width: showExtendedMenu ? 70 : 60, height: showExtendedMenu ? 70 : 60)
                        .foregroundColor(Color("ThemeColor"))
                        .shadow(color: Color.black.opacity(showExtendedMenu ? 0.3 : 0.2), radius: showExtendedMenu ? 10 : 5, x: showExtendedMenu ? 0 : 5, y: showExtendedMenu ? 0 : 5)
                        .shadow(color: Color.white.opacity(showExtendedMenu ? 0 : 1), radius: 5, x: -5, y: -5)
                    
                    Image(systemName: "arrowtriangle.up.fill")
                        .resizable()
                        .foregroundColor(arrowCondition ? Color("IconColor") : Color("FontColor").opacity(0.5))
                        .frame(width: 20, height: 17)
                        .rotation3DEffect(
                            .degrees(showExtendedMenu ? 180 : 0),
                            axis: (x: -10.0, y: 0.0, z: 0.0)
                        )
                }
            }
            .offset(y: showExtendedMenu ? -25 : -5)
            .buttonStyle(SinkInButtonStyle())
            .animation(.easeInOut(duration: 0.2))
        }
    }
}


struct HUDNotification: View {
    var body: some View {
        HStack {
            Image(systemName: "cart.fill")
            
            Text("Saved to cart")
        }
        .font(.headline)
        .foregroundColor(.black)
        .padding(.vertical, 18)
        .padding(.horizontal, 30)
        .background(Color("ThemeColor"))
        .clipShape(Capsule())
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 5, y: 5)
        .shadow(color: Color.white, radius: 5, x: -5, y: -5)
    }
}




//struct MainView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainView(showMainView: .constant(true))
//            .environmentObject(User())
//            .environmentObject(UserStore())
//            .environmentObject(Store())
//    }
//}
