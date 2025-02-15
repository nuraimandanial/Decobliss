//
//   Cart.swift
//   Decobliss
//
//   Created by @kinderBono on 26/05/2024.
//   

import Foundation

struct Cart: Identifiable, Codable, Hashable {
    var id = UUID()
    
    var product: Product
    var quantity: Int = 1
    var price: Float {
        product.price * Float(quantity)
    }
}

extension Array where Element == Cart {
    var uniqueSellers: Set<String> {
        return Set(self.map { $0.product.seller ?? "" })
    }
}
