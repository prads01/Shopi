
import SwiftUI
import Firebase

class User: ObservableObject {
    @Published var info: UserModel? = nil
    @Published var isLogged = UserDefaults.standard.bool(forKey: "isLogged") {
        didSet {
            UserDefaults.standard.set(isLogged, forKey: "isLogged")
        }
    }
    var handle: AuthStateDidChangeListenerHandle?
    
    func listen() {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                withAnimation(.easeInOut) {
                    self.info = UserModel(
                        id: user.uid,
                        displayName: user.displayName,
                        email: user.email
                    )
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
                    withAnimation { self.isLogged = true }
                }
            } else {
                withAnimation {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
                        self.isLogged = false
                    }
                    self.info = nil
                }
            }
        }
    }
    
    
    // MARK: - LOGIN FUNCTION
    
    @Published var isLoginLoading: Bool = false
    @Published var isLoginProcessing: Bool = false
    @Published var showLoginAlert: Bool = false
    @Published var loginAlertMessage: String = ""
    @Published var loginAlertImage: String = ""
    
    func Login(email: String, password: String) {
        withAnimation(.spring()) {
            isLoginProcessing = true
            isLoginLoading = true
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                haptic(type: .error)
                
                self.loginAlertMessage = error!.localizedDescription
                self.loginAlertImage = "failed"
                
                withAnimation(.spring()) {
                    self.isLoginLoading = false
                    self.showLoginAlert = true
                }
            } else {
                haptic(type: .success)
                
                self.loginAlertMessage = "Login Successful!"
                self.loginAlertImage = "success"
                
                withAnimation(.spring()) {
                    self.isLoginLoading = false
                    self.showLoginAlert = true
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.showLoginAlert = false
                        self.isLoginProcessing = false
                    }
                }
            }
            
            if !self.showLoginAlert {
                self.loginAlertMessage = ""
                self.loginAlertImage = ""
            }
        }
    }
    
    
    // MARK: - SIGNUP FUNCTION
    
    @Published var isSignUpLoading: Bool = false
    @Published var isSignUpProcessing: Bool = false
    @Published var showSignUpAlert: Bool = false
    @Published var signUpAlertMessage: String = ""
    @Published var signUpAlertImage: String = ""
    
    func SignUp(name: String, email: String, password: String) {
        withAnimation(.spring()) {
            isSignUpProcessing = true
            isSignUpLoading = true
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error != nil {
                haptic(type: .error)
                
                self.signUpAlertMessage = error!.localizedDescription
                self.signUpAlertImage = "failed"
                
                withAnimation(.spring()) {
                    self.isSignUpLoading = false
                    self.showSignUpAlert = true
                }
            } else {
                haptic(type: .success)
                
                self.signUpAlertMessage = "Your account has been created successfully!"
                self.signUpAlertImage = "success"
                
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = name
                changeRequest?.commitChanges(completion: { (error) in
                    if error != nil {
                        print("\(error?.localizedDescription ?? "")")
                    } else {
                        print("Profile Updated")
                    }
                })
                
                withAnimation(.spring()) {
                    self.isSignUpLoading = false
                    self.showSignUpAlert = true
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.showSignUpAlert = false
                        self.isSignUpProcessing = false
                    }
                }
            }
            
            if !self.showSignUpAlert {
                self.signUpAlertMessage = ""
                self.signUpAlertImage = ""
            }
        }
    }
    
    
    // MARK: - SIGN OUT FUNCTION
    
    @Published var isSignOutLoading: Bool = false
    
    func SignOut() {
        do {
            try Auth.auth().signOut()
            withAnimation(.easeInOut) {
                isSignOutLoading = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.isSignOutLoading = false
                }
            }
        } catch {
            
        }
    }
    
    
    // MARK: - DELETE FUNCTION
    
    func Delete() {
        let user = Auth.auth().currentUser
        
        user?.delete(completion: { (error) in
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                return
            }
        })
    }
}
