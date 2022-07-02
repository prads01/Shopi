
import SwiftUI
import Firebase

struct UserModel: Identifiable {
    var id = UUID().uuidString
    var displayName: String?
    var email: String?
}
