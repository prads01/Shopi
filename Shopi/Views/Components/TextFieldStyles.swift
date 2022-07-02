
import SwiftUI

struct CustomTextField: UIViewRepresentable {

    class Coordinator: NSObject, UITextFieldDelegate {

        @Binding var text: String
        var didBecomeFirstResponder = false

        init(text: Binding<String>) {
            _text = text
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }

    }

    @Binding var text: String
    var isFirstResponder: Bool = false

    func makeUIView(context: UIViewRepresentableContext<CustomTextField>) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.placeholder = "Search"
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .search
        textField.clearButtonMode = .whileEditing
        textField.enablesReturnKeyAutomatically = true
        textField.delegate = context.coordinator
        return textField
    }

    func makeCoordinator() -> CustomTextField.Coordinator {
        return Coordinator(text: $text)
    }

    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<CustomTextField>) {
        uiView.text = text
        if isFirstResponder && !context.coordinator.didBecomeFirstResponder  {
            uiView.becomeFirstResponder()
            context.coordinator.didBecomeFirstResponder = true
        }
    }
}



struct LoginTextFieldStyle : TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.system(size: 16, design: .serif))
            .foregroundColor(Color("IconColor"))
            .padding(.vertical, 10)
            .padding(.leading, 15)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}


struct SearchBarTextFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 20))
                .foregroundColor(Color(.systemGray))
                .padding(.leading, 10)
            
            content
                .font(.system(size: 16, design: .default))
                .foregroundColor(Color("FontColor"))
                .accentColor(Color("FontColor").opacity(0.8))
                .padding(.vertical, 6)
                .padding(5)
                .disableAutocorrection(true)
        }
        .frame(width: screen.width * 0.9, height: 40)
        .background(Color(.systemGray5).opacity(0.6))
        .cornerRadius(12)
    }
}



struct GeneralTextFieldStyle: ViewModifier {
    var icon: String
    var selected: Bool
    
    var width: CGFloat {
        if selected {
            return 6
        } else {
            return 35
        }
    }
    
    var height: CGFloat {
        if selected {
            return 40
        } else {
            return 25
        }
    }
    
    func body(content: Content) -> some View {
        ZStack(alignment: .leading) {
            content
                .font(.system(size: 16, design: .serif))
                .foregroundColor(Color("IconColor"))
                .padding(.vertical, 10)
                .padding(.leading, selected ? 15 : 45)
                .disableAutocorrection(true)
            
            Image(systemName: icon)
                .modifier(IconModifier())
                .frame(width: width)
                .scaleEffect(selected ? 0 : 1)
                .opacity(selected ? 0 : 1)
                .background(
                    Capsule()
                        .frame(width: width, height: height)
                        .foregroundColor(Color("IconColor"))
                        .scaleEffect(selected ? 1 : 0)
                        .opacity(selected ? 1 : 0)
                )
        }
        .animation(.easeInOut)
        .frame(width: screen.width * 0.8)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}



struct PasswordField: ViewModifier {
    var icon: String
    var color: Color
    
    func body(content: Content) -> some View {
        ZStack(alignment: .leading) {
            content
                .font(.system(size: 16, design: .serif))
                .autocapitalization(.none)
                .foregroundColor(Color("IconColor"))
                .padding(.vertical, 10)
                .padding(.leading, 45)
                .disableAutocorrection(true)
            
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
                .frame(width: 35)
        }
        .animation(.easeInOut)
        .frame(width: screen.width * 0.8)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
