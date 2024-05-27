//
//   Order.swift
//   Decobliss
//
//   Created by @kinderBono on 26/05/2024.
//   

import Foundation

struct Order: Identifiable, Codable, Hashable {
    var id = UUID()
    
    var name: String = ""
    var carts: [Cart]
    var deliveryAddress: Address
    var shippingType: ShippingType
    var subTotal: Float {
        return carts.reduce(0) { $0 + $1.price }
    }
    var shippingTotal: Float
    var total: Float {
        subTotal + shippingTotal
    }
    var payment: Payment
}
