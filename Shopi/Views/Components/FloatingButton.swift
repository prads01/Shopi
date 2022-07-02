
import SwiftUI

struct FloatingButton: View {
    @Binding var index: Int
    @Binding var showExtendedMenu: Bool
    @Binding var extendedMenuSelected: Bool
    
    var body: some View {
        ZStack {
            Button(action: {
                impact(style: .light)
                index = 5
                extendedMenuSelected = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation(Animation.timingCurve(0.49, 0.5, 0.34, 0.82)) {
                        showExtendedMenu.toggle()
                    }
                }
            }) {
                ZStack {
                    Circle()
                        .foregroundColor(Color("ThemeColor"))
                        .frame(width: 60, height: 60)
                        .shadow(color: Color.black.opacity(0.3), radius: 10)
                    
                    Image(systemName: index == 5 ? "creditcard.fill" : "creditcard")
                        .font(.title2)
                        .foregroundColor(index == 5 ? Color("IconColor") : Color("FontColor").opacity(0.5))
                }
            }
            .offset(x: showExtendedMenu ? -80 : 0, y: showExtendedMenu ? -90 : -5)
            
            Button(action: {
                impact(style: .light)
                index = 6
                extendedMenuSelected = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation(Animation.timingCurve(0.49, 0.5, 0.34, 0.82)) {
                        showExtendedMenu.toggle()
                    }
                }
            }) {
                ZStack {
                    Circle()
                        .foregroundColor(Color("ThemeColor"))
                        .frame(width: 60, height: 60)
                        .shadow(color: Color.black.opacity(0.3), radius: 10)
                    
                    Image(systemName: index == 6 ? "person.crop.circle.fill" : "person.crop.circle")
                        .font(.title2)
                        .foregroundColor(index == 6 ? Color("IconColor") : Color("FontColor").opacity(0.5))
                }
            }
            .offset(x: showExtendedMenu ? 0 : 0, y: showExtendedMenu ? -140 : -5)
            .zIndex(1)
            
            Button(action: {
                impact(style: .light)
                index = 7
                extendedMenuSelected = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation(Animation.timingCurve(0.49, 0.5, 0.34, 0.82)) {
                        showExtendedMenu.toggle()
                    }
                }
            }) {
                ZStack {
                    Circle()
                        .foregroundColor(Color("ThemeColor"))
                        .frame(width: 60, height: 60)
                        .shadow(color: Color.black.opacity(0.3), radius: 10)
                    
                    Image(systemName: index == 7 ? "gearshape.fill" : "gearshape")
                        .font(.title2)
                        .foregroundColor(index == 7 ? Color("IconColor") : Color("FontColor").opacity(0.5))
                }
            }
            .offset(x: showExtendedMenu ? 80 : 0, y: showExtendedMenu ? -90 : -5)
        }
        .buttonStyle(SinkInButtonStyle())
        .scaleEffect(showExtendedMenu ? 1 : 0)
        .opacity(showExtendedMenu ? 1 : 0)
        .animation(.easeInOut)
    }
}

struct FloatingButton_Previews: PreviewProvider {
    static var previews: some View {
        FloatingButton(index: .constant(1), showExtendedMenu: .constant(false), extendedMenuSelected: .constant(false))
    }
}
