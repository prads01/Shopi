
import SwiftUI

struct SearchBarView: View {
    @State var keyboard = KeyboardResponder()
    @Binding var search: String
    @Binding var searchSelected: Bool
    
    var body: some View {
        VStack {
            CustomTextField(text: $search, isFirstResponder: true)
                .modifier(SearchBarTextFieldStyle())
                .padding(.top, !search.isEmpty ? edge!.top : 0)


            if !search.isEmpty {
                ScrollView {
                    VStack(alignment: .leading, spacing: 5) {
                        ForEach(
                            CountryList.filter {
                                $0.localizedStandardContains(search)
                            },
                            id: \.self
                        ) { country in
                            Text(country)
                                .frame(height: 40)
                                .padding(.horizontal, 30)
                            
                            Rectangle()
                                .frame(width: screen.width * 0.8, height: 1)
                                .foregroundColor(Color(.systemGray5))
                                .frame(width: screen.width)
                                .transition(.opacity)
                        }
                    }
                    .frame(width: screen.width)
                }
            }
            
            Spacer()
        }
        .frame(width: !search.isEmpty ? screen.width : screen.width * 0.8, height: !search.isEmpty ? (screen.height - (keyboard.currentHeight)) : 40)
        .background(Color("ThemeColor"))
        .animation(.easeOut(duration: 0.2))
    }
}




struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(search: .constant(""), searchSelected: .constant(false))
    }
}
