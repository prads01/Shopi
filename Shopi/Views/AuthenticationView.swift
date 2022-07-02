
import SwiftUI

struct AuthenticationView: View {
    @EnvironmentObject var user: User
    @State private var showSignUpView: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                LoginView()
                    .scaleEffect(showSignUpView ? 0.96 : 1)
                    .offset(y: showSignUpView ? -30 : 0)
                    .animation(.easeInOut)
                
                Spacer()
                
                HStack {
                    Text("New user?")
                    
                    Button(action: {
                        impact(style: .heavy)
                        hideKeyBoard()
                        
                        withAnimation { showSignUpView = true }
                    }) {
                        Text("Create an Account.")
                            .foregroundColor(Color("IconColor"))
                    }
                }
                .font(.system(.subheadline, design: .serif))
                .foregroundColor(Color("FontColor"))
            }
            .scaleEffect((user.isLoginProcessing || user.isSignUpProcessing) ? 0.96 : 1)
            .opacity((user.isLoginProcessing || user.isSignUpProcessing) ? 0.6 : 1)
            .animation(.easeInOut)
            
            
            if showSignUpView {
                ZStack {
                    SignUpView(showSignUpView: $showSignUpView)
                    
                    if user.isSignUpProcessing {
                        Color.black.opacity(0.4)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .edgesIgnoringSafeArea(.all)
                            .transition(.opacity)

                        ZStack {
                            if user.isSignUpLoading {
                                LoadingView()
                            }

                            if user.showSignUpAlert {
                                if user.info == nil {
                                    AlertView(isPresented: $user.showSignUpAlert, image: user.signUpAlertImage, message: user.signUpAlertMessage, dismissButton: "OK")
                                        .zIndex(1)
                                } else {
                                    AlertView(image: user.signUpAlertImage, message: user.signUpAlertMessage)
                                        .zIndex(1)
                                }
                            }
                        }
                    }
                }
                .zIndex(1)
                .transition(AnyTransition.move(edge: .bottom))
            }
            
            
            
            if user.isLoginProcessing {
                Color.black.opacity(0.4)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.all)
                    .transition(.opacity)
                
                if user.isLoginLoading {
                    LoadingView()
                }
                
                if user.showLoginAlert {
                    if user.info == nil {
                        AlertView(isPresented: $user.showLoginAlert, image: user.loginAlertImage, message: user.loginAlertMessage, dismissButton: "OK")
                            .zIndex(1)
                    } else {
                        AlertView(image: user.loginAlertImage, message: user.loginAlertMessage)
                            .zIndex(1)
                    }
                }
            }
        }
        .padding(.top, edge?.top)
        .padding(.bottom, edge?.bottom)
        .frame(width: screen.width, height: screen.height)
        .background(Color("ThemeColor"))
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            user.listen()
        }
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
            .environmentObject(User())
    }
}
