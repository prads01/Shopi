//
//  UserStore.swift
//  Shopi
//
//  Created by Praduyt Sen on 12/09/20.
//

import SwiftUI

class UserStore: ObservableObject {
    // MARK: - USER STORE
    
    // MARK: - CART
    
    @Published var cartItems: [CartModel] = [
        CartModel(name: "LG 32-inch UltraFine 4K UHD LED", category: "Electronics", image: "lgMonitor", price: 1299.99, quantity: 1),
        CartModel(name: "MacBook Aluminium Stand", category: "Electronics", image: "macbookStand", price: 45.00, quantity: 1),
        CartModel(name: "Thunderbolt 3 Pro Cable (2 m)", category: "Electronics", image: "thunderbolt", price: 129.00, quantity: 1)
    ]
    
    @Published var savedForLaterItems = [CartModel]()
    
    // MARK: - ORDERS
    
    @Published var arrivingOrdersList = [
        ItemModel(name: "MacBook Pro 16-inch", category: "Electronics", image: "macbook", price: 2599.00, quantity: 1),
        ItemModel(name: "USB-C Digital AV Multiport Adapter", category: "Electronics", image: "dongle", price: 69.00, quantity: 1)
    ]
    
    
    @Published var orderHistoryList = [
        ItemModel(name: "Audio Technica AT2020", category: "Electronics", image: "at2020", price: 99.00, quantity: 1),
        ItemModel(name: "Logitech BRIO Ultra HD Webcam", category: "Electronics", image: "logitech", price: 264.99, quantity: 1)
    ]
    
    // MARK: - FUNCTIONS
    
    func CartTotalAmount() -> CGFloat {
        var amount: CGFloat = 0.0
        
        cartItems.forEach { item in
            amount += (item.price * CGFloat(item.quantity))
        }
        
        return amount
    }
    
    func AddToCart(_ item: CartModel) {
        var index = 0
        
        cartItems.forEach { i in
            if item.id == i.id {
                if cartItems[index].quantity < 9 {
                    cartItems[index].quantity += 1
                }
                return
            } else {
                index += 1
            }
        }
        
        if index == cartItems.count {
            cartItems.insert(
                CartModel(
                    id: item.id,
                    name: item.name,
                    category: item.category,
                    image: item.image,
                    price: item.price,
                    quantity: item.quantity
                ),
                at: 0
            )
        }
    }
    
    func RemoveFromCart(_ item: CartModel) {
        var index = 0
        
        cartItems.forEach { i in
            if item.id == i.id {
                cartItems.remove(at: index)
                return
            } else {
                index += 1
            }
        }
    }
    
    func SaveForLater(_ item: CartModel) {
        savedForLaterItems.insert(
            CartModel(
                id: item.id,
                name: item.name,
                category: item.category,
                image: item.image,
                price: item.price,
                quantity: item.quantity
            ),
            at: 0
        )
    }
    
    func RemoveFromSaved(_ item: CartModel) {
        var index = 0
        
        savedForLaterItems.forEach { i in
            if item.id == i.id {
                savedForLaterItems.remove(at: index)
                return
            } else {
                index += 1
            }
        }
    }
    
    
    enum action {
        case decrease
        case increase
    }
    
    func ChangeQuantity(of item: CartModel, action: action) {
        var index = 0
        
        if action == .decrease {
            index = 0
            
            if item.quantity > 1 {
                impact(style: .soft)
                cartItems.forEach { i in
                    if item.id == i.id {
                        cartItems[index].quantity -= 1
                        return
                    } else {
                        index += 1
                    }
                }
            } else {
                RemoveFromCart(item)
                haptic(type: .warning)
            }
        } else if action == .increase && item.quantity < 9 {
            index = 0
            impact(style: .soft)
            cartItems.forEach { i in
                if item.id == i.id {
                    cartItems[index].quantity += 1
                    return
                } else {
                    index += 1
                }
            }
        }
    }
    
    func PlaceOrder() {
        cartItems.forEach { item in
            arrivingOrdersList.insert(
                ItemModel(
                    id: item.id,
                    name: item.name,
                    category: item.category,
                    image: item.image,
                    price: item.price,
                    quantity: item.quantity
                ),
                at: 0
            )
        }
        
        cartItems.removeAll()
    }
}
