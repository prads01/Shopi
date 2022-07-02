
import SwiftUI



func haptic(type: UINotificationFeedbackGenerator.FeedbackType) {
    UINotificationFeedbackGenerator().notificationOccurred(type)
}

func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
    UIImpactFeedbackGenerator(style: style).impactOccurred()
}



struct SinkInButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
    }
}



struct AlertButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(BlurView(style: .systemThinMaterialLight))
            .background(Color.black.opacity(configuration.isPressed ? 0.2 : 0))
    }
}



struct IconModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 20))
            .foregroundColor(Color("IconColor"))
    }
}


struct RequiredModifier: ViewModifier {
    @EnvironmentObject var user: User
    
    var showAlert: Bool
    var isEmpty: Bool
    
    func body(content: Content) -> some View {
        ZStack(alignment: .trailing) {
            content
            
            Text("*")
                .font(.caption)
                .foregroundColor(.red)
                .padding(.trailing, 10)
                .opacity((showAlert && isEmpty) ? 1 : 0)
                .animation(.easeInOut)
        }
        .frame(width: screen.width * 0.67)
    }
}



struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
