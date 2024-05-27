//
//   Reward.swift
//   Decobliss
//
//   Created by @kinderBono on 26/05/2024.
//   

import Foundation

//no real variable yet
struct Reward: Identifiable, Codable, Hashable {
    var id = UUID()
    
    var name: String = ""
    var image: String = "gift_voucher"
    var categories: [Category] = []
}

extension Reward {
    static let rewards = [
        Reward(name: "", categories: [.desk, .lamp]),
        Reward(name: "", categories: [.officeChair]),
        Reward(name: "", categories: [.pillow]),
        Reward(name: "", categories: [.headphones]),
        Reward(name: "", categories: [.officeChair]),
        Reward(name: "", categories: [.desk]),
        Reward(name: "", categories: [.headphones])
    ]
}

extension Array where Element == Reward {
    func filterAndSort(by category: Category?) -> [Reward] {
        if category == .all {
            return self
        } else {
            return self.filter { reward in
                category == nil || reward.categories.contains(category!)
            }
        }
    }
}
