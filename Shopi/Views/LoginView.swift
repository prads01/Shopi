
import SwiftUI

extension View {
    func hideKeyBoard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func required(_ show: Bool, if isEmpty: Bool) -> some View {
        self.modifier(RequiredModifier(showAlert: show, isEmpty: isEmpty))
    }
}

struct LoginView: View {
    @EnvironmentObject var user: User
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var requiredAlert: String = ""
    @State private var showRequiredAlert: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                LoginPage(email: $email, password: $password, requiredAlert: $requiredAlert, showRequiredAlert: $showRequiredAlert)
                
                Button(action: {
                    guard !email.isEmpty || !password.isEmpty else {
                        haptic(type: .error)
                        withAnimation { showRequiredAlert = true }
                        requiredAlert = "Please fill the required fields"
                        return
                    }
                    
                    impact(style: .medium)
                    hideKeyBoard()
                    
                    user.Login(email: email, password: password)
                }) {
                    Text("Login")
                        .font(.system(size: 18, weight: .medium, design: .serif))
                        .foregroundColor(Color.white)
                        .frame(width: screen.width*0.75, height: 40)
                        .background(Color("IconColor"))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .buttonStyle(SinkInButtonStyle())
                .padding(.top, 20)
                .animation(.easeInOut(duration: 0.2))
            }
        }
        .onAppear {
            user.listen()
            
            if user.info != nil {
                email = ""
                password = ""
            }
        }
    }
}


struct LoginPage: View {
    @EnvironmentObject var user: User
    @Binding var email: String
    @Binding var password: String
    @Binding var requiredAlert: String
    @Binding var showRequiredAlert: Bool
    
    var body: some View {
        VStack {
            Text("SHOPI")
                .font(.custom("didot", size: 50))
                .bold()
                .padding(.top, 30)
            
            
            Image("loginImage")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 350)
                .padding(.bottom, 5)
            
            VStack(spacing: 10) {
                HStack(spacing: 10) {
                    Image(systemName: "person.fill")
                        .modifier(IconModifier())
                    
                    TextField("Email address", text: $email)
                        .textFieldStyle(LoginTextFieldStyle())
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .required(showRequiredAlert, if: email.isEmpty)
                }
                
                HStack(spacing: 10) {
                    Image(systemName: "lock.fill")
                        .modifier(IconModifier())
                    
                    SecureField("Password", text: $password)
                        .textFieldStyle(LoginTextFieldStyle())
                        .required(showRequiredAlert, if: password.isEmpty)
                }
                
                Button(action: {
                    
                }) {
                    Text("Forgot Password?")
                        .font(.system(.subheadline, design: .serif))
                        .foregroundColor(Color("IconSecondaryColor"))
                }
                
                if showRequiredAlert && (email.isEmpty || password.isEmpty) {
                    Text(requiredAlert)
                        .font(.system(.subheadline, design: .serif))
                        .foregroundColor(Color.red.opacity(0.8))
                        .transition(AnyTransition.scale.combined(with: .opacity))
                        .animation(.none)
                        .frame(width: screen.width * 0.67, alignment: .center)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}




struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(User())
    }
}
