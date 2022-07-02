
import SwiftUI

struct ItemModel: Identifiable {
    var id = UUID()
    var name: String
    var category: String
    var image: String
    var price: CGFloat
    var quantity: Int
}

struct CartModel: Identifiable {
    var id = UUID()
    var name: String
    var category: String
    var image: String
    var price: CGFloat
    var quantity: Int
}

class Store: ObservableObject {
    
    // MARK: - CATEGORIES
    
    @Published var categories: [String] = ["Fashion", "Electronics", "Sports", "Kitchen", "Grocery", "Car", "Books", "Toys"]
    
    
    // MARK: - LATEST ARRIVALS
    
    @Published var latestArrivalList: [ItemModel] = [
        ItemModel(name: "Google Pixel 4A (Black)", category: "Electronics", image: "pixel4a", price: 349.99, quantity: 1),
        ItemModel(name: "Nike Zoom Freak 2 By You", category: "Fashion", image: "nike1", price: 140.00, quantity: 1),
        ItemModel(name: "Sony α7S III", category: "Electronics", image: "sonyA7S", price: 3499.99, quantity: 1)
    ]
}
