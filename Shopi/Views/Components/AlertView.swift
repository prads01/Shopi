
import SwiftUI

struct AlertView: View {
    @EnvironmentObject var user: User
    
    @Binding var isPresented: Bool
    var image: String
    var message: String
    var dismissButton: String
    
    public init(image: String, message: String) {
        self._isPresented = .constant(false)
        self.image = image
        self.message = message
        self.dismissButton = ""
    }
    
    public init(isPresented: Binding<Bool>, image: String, message: String, dismissButton: String) {
        self._isPresented = isPresented
        self.image = image
        self.message = message
        self.dismissButton = dismissButton
    }
    
    var body: some View {
        VStack(spacing: 12) {
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 250, height: 220)
            
            Text(message)
                .font(.system(size: 18, design: .serif))
                .foregroundColor(Color("FontColor"))
                .frame(width: 280, height: 80)
                .multilineTextAlignment(.center)
            
            if !dismissButton.isEmpty {
                VStack(spacing: 0) {
                    Rectangle()
                        .frame(width: 320, height: 1)
                        .foregroundColor(Color.gray.opacity(0.5))

                    Button(action: {
                        impact(style: .soft)
                        withAnimation {
                            self.isPresented = false
                            
                            if !user.showLoginAlert && user.isLoginProcessing {
                                    withAnimation { user.isLoginProcessing = false }
                            }
                            
                            if !user.showSignUpAlert && user.isSignUpProcessing {
                                    withAnimation { user.isSignUpProcessing = false }
                            }
                        }
                    }) {
                        Text(dismissButton)
                            .font(.headline)
                            .foregroundColor(Color("IconColor"))
                            .frame(width: 320, height: 50)
                    }
                    .buttonStyle(AlertButtonStyle())
                }
            }
        }
        .frame(width: 300, alignment: .center)
        .padding([.horizontal, .top], 10)
        .background(BlurView(style: .systemThickMaterialLight))
        .transition(AnyTransition.scale(scale: 1.1).combined(with: .opacity))
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
    }
}

struct AlertView_Previews: PreviewProvider {
    static var previews: some View {
        AlertView(image: "loginSuccess", message: "Login Successful!")
    }
}
