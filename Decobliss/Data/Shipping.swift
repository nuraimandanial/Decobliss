//
//   Shipping.swift
//   Decobliss
//
//   Created by @kinderBono on 26/05/2024.
//   

import Foundation

struct Shipping: Identifiable, Codable, Hashable {
    var id = UUID()
    
    var name: String
    var type: ShippingType
}

extension Shipping {
    static let options = [
        Shipping(name: "Door-Step Delivery", type: .doorStep),
        Shipping(name: "Self Pickup", type: .selfPickup)
    ]
}

enum ShippingType: Codable, Hashable {
    case selfPickup, doorStep
}
