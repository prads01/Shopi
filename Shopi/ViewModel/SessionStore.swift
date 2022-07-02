
import SwiftUI
import Firebase

class SessionStore: ObservableObject {
    @Published var session: UserModel?
    var handle: AuthStateDidChangeListenerHandle?
    @Published var isLoggedIn = false
    @Published var isSignedOut = false
    @Published var deleteError = ""
    
    func listen() {
        // monitor authentication changes using firebase
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                // if we have a user, create a new user model
                print("Got user: \(user)")
                withAnimation(.easeInOut) {
                    self.session = UserModel(
                        id: user.uid,
                        displayName: user.displayName,
                        email: user.email
                    )
                }
            } else {
                // if we don't have a user, set our session to nil
                self.session = nil
            }
        }
    }
    
    func signUp(
        email: String,
        password: String,
        handler: @escaping AuthDataResultCallback
    ) {
        Auth.auth().createUser(withEmail: email, password: password, completion: handler)
    }
    
    func signIn(
        email: String,
        password: String,
        handler: @escaping AuthDataResultCallback
    ) {
        Auth.auth().signIn(withEmail: email, password: password, completion: handler)
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.session = nil
            self.isSignedOut = true
            self.isLoggedIn = false
        } catch {
            self.isSignedOut = false
            self.isLoggedIn = true
        }
    }
    
    func delete(){
        let user = Auth.auth().currentUser
        
        user?.delete(completion: { (error) in
            if let error = error {
                self.deleteError = error.localizedDescription
                return
            } else {
                self.deleteError = "Deleted"
                self.signOut()
                return
            }
        })
    }
    
    func unbind() {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}
