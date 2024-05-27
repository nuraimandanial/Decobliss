//
//   Product.swift
//   Decobliss
//
//   Created by @kinderBono on 26/05/2024.
//   

import Foundation

struct Product: Identifiable, Codable, Hashable {
    var id = UUID()
    
    var name: String
    var price: Float
    var images: [String] = []
    var description: String = ""
    var rating: Float = 0
    var category: [Category] = []
    
    var seller: UUID?
}

struct Category: Identifiable, Codable, Hashable {
    var id = UUID()
    
    var type: String
    var image: String = ""
}

extension Category {
    static let allCategory = [all, officeChair, desk, headphones, lamp, pillow]
    
    static let all = Category(type: "All", image: "command")
    static let officeChair = Category(type: "Office Chair", image: "chair.fill")
    static let desk = Category(type: "Desk", image: "table.furniture")
    static let headphones = Category(type: "Headphones", image: "headphones")
    static let lamp = Category(type: "Lamp", image: "light.cylindrical.ceiling")
    static let pillow = Category(type: "Pillow", image: "bed.double")
}
