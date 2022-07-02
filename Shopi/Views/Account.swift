
import SwiftUI

struct Account: View {
    @EnvironmentObject var user: User
    
    var body: some View {
        ZStack {
            VStack(spacing: 40) {
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 15) {
                        Text("Name:")
                        Text((user.info?.displayName) ?? "-NA-")
                    }
                    HStack(spacing: 15) {
                        Text("Email:")
                        Text((user.info?.email) ?? "-NA-")
                    }
                    HStack(spacing: 15) {
                        Text("ID:")
                        Text((user.info?.id) ?? "-NA-")
                    }
                }
                
                Button(action: {
                    user.SignOut()
                }) {
                    HStack {
                        Image(systemName: "arrow.right.square.fill")
                        Text("Sign Out")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .padding(.horizontal, 10)
                    .background(Color.red)
                    .cornerRadius(20)
                }
                .buttonStyle(SinkInButtonStyle())
                .animation(.easeInOut(duration: 0.3))
                
                Button(action: {
                    user.Delete()
                }) {
                    HStack {
                        Image(systemName: "trash.fill")
                        Text("Delete")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .padding(.horizontal, 10)
                    .background(Color.red)
                    .cornerRadius(20)
                }
                .buttonStyle(SinkInButtonStyle())
                .animation(.easeInOut(duration: 0.3))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear(perform: user.listen)
    }
}

struct Account_Previews: PreviewProvider {
    static var previews: some View {
        Account()
            .environmentObject(User())
    }
}
