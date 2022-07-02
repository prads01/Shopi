
import SwiftUI

struct OnBoardingView: View {
    @StateObject var user = User()
    @StateObject var userStore = UserStore()
    @StateObject var store = Store()
    
    @State private var show: Bool = false
    @State private var showMainView = false
    
    var body: some View {
        if user.isLogged {
            VStack {
                Text("SHOPI")
                    .font(.system(size: 50, weight: .semibold, design: .serif))
                    .foregroundColor(Color("FontColor"))
                    .scaleEffect(show ? 1.1 : 1.0)
                    .animation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true))
                    .onAppear { show = true }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("ThemeColor"))
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                user.listen()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    if user.info != nil {
                        showMainView = true
                    } else {
                        showMainView = false
                    }
                }
            }
            .fullScreenCover(isPresented: $showMainView) {
                MainView(showMainView: $showMainView)
                    .environmentObject(user)
                    .environmentObject(userStore)
                    .environmentObject(store)
                    .preferredColorScheme(.light)
            }
        } else {
            AuthenticationView()
                .transition(AnyTransition.asymmetric(insertion: .move(edge: .top), removal: .scale(scale: 0.3)).combined(with: .opacity))
                .environmentObject(user)
                .environmentObject(userStore)
                .environmentObject(store)
                .preferredColorScheme(.light)
        }
    }
}


struct OnBoardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingView()
            .environmentObject(User())
    }
}
