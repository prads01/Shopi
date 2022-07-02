
import SwiftUI

struct SignUpView: View {
    @Binding var showSignUpView: Bool
    
    @EnvironmentObject var user: User
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirm: String = ""
    @State private var index: String = ""
    @State private var requiredAlert: String = ""
    @State private var showRequiredAlert: Bool = false
    
    func getSelected(_ index: String) -> Bool {
        for _ in 1...4 {
            if index == self.index {
                return true
            } else {
                return false
            }
        }
        
        return false
    }
    
    private func checkPassword() -> Color {
        if !password.isEmpty && !confirm.isEmpty {
            if password != confirm {
                return Color.red
            } else {
                impact(style: .soft)
                return Color.green
            }
        }
        
        return Color("IconColor")
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 50) {
                Text("Sign Up")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(Color("FontColor"))
                    .padding(.top, 20)
                
                VStack(spacing: 20) {
                    TextField("Full Name", text: $name) { edit in
                        if edit {
                            index = "name"
                        } else {
                            index = ""
                        }
                    }
                    .modifier(GeneralTextFieldStyle(icon: "person.fill", selected: getSelected("name")))
                    .required(showRequiredAlert, if: name.isEmpty)
                    
                    TextField("Email address", text: $email) { edit in
                        if edit {
                            index = "email"
                        } else {
                            index = ""
                        }
                    }
                    .modifier(GeneralTextFieldStyle(icon: "envelope.fill", selected: getSelected("email")))
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .required(showRequiredAlert, if: email.isEmpty)
                    
                    Rectangle()
                        .foregroundColor(Color.gray.opacity(0.4))
                        .frame(width: screen.width * 0.7, height: 1)
                    
                    Group {
                        SecureField("Password", text: $password)
                            .modifier(PasswordField(icon: "lock.fill", color: checkPassword()))
                            .required(showRequiredAlert, if: password.isEmpty)
                        
                        SecureField("Confirm password", text: $confirm)
                            .modifier(PasswordField(icon: "lock.shield", color: checkPassword()))
                            .required(showRequiredAlert, if: confirm.isEmpty)
                    }
                }
                
                
                Button(action: {
                    index = ""
                    
                    guard !email.isEmpty || !password.isEmpty || !confirm.isEmpty else {
                        haptic(type: .error)
                        withAnimation { showRequiredAlert = true }
                        requiredAlert = "Please fill the required fields"
                        return
                    }
                    
                    impact(style: .medium)
                    hideKeyBoard()
                    
                    user.SignUp(name: name, email: email, password: confirm)
                }) {
                    Text("Sign Up")
                        .font(.system(size: 18, weight: .medium, design: .serif))
                        .foregroundColor(Color.white)
                        .frame(width: screen.width * 0.8, height: 40)
                        .background(Color("IconColor"))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                
                Spacer()
            }
            
            
            VStack {
                HStack {
                    Spacer()
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 30, design: .rounded))
                        .foregroundColor(Color("IconColor").opacity(0.75))
                        .padding(.top, 20)
                        .padding(.trailing, 25)
                        .onTapGesture {
                            withAnimation { showSignUpView = false }
                    }
                }
                Spacer()
            }
        }
        .padding(.top, edge?.top)
        .frame(width: screen.width, height: screen.height)
        .background(Color("ThemeColor"))
        .edgesIgnoringSafeArea(.all)
        .onTapGesture {
            index = ""
            hideKeyBoard()
        }
        .onAppear {
            user.listen()
            
            if user.info != nil {
                name = ""
                email = ""
                password = ""
                confirm = ""
                
                withAnimation { showSignUpView = false }
            }
        }
    }
}




struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(showSignUpView: .constant(true)).environmentObject(User())
    }
}
