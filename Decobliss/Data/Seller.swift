//
//   Seller.swift
//   Decobliss
//
//   Created by @kinderBono on 26/05/2024.
//   

import Foundation

struct Seller: Identifiable, Codable, Hashable {
    var id: UUID {
        profile.id
    }
    
    var profile = Profile()
    var address: Address = Address()
}
