
import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            LottieView(fileName: "loading4")
                .frame(width: 200, height: 200)
            
            Text("Loading...")
                .font(.system(.title3, design: .serif))
                .bold()
        }
        .frame(width: 300, height: 300)
        .background(BlurView(style: .systemThickMaterialLight))
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .transition(AnyTransition.asymmetric(insertion: .scale(scale: 1.3), removal: .scale(scale: 0.95)).combined(with: .opacity))
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
