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
    
    var seller: String?
}

extension Array where Element == Product {
    func filterAndSort(by category: Category?) -> [Product] {
        if category == .all {
            return self.sorted { (one, two) -> Bool in
                return one.rating > two.rating
            }
        } else {
            return self.filter { product in
                category == nil || product.category.contains(category!)
            }.sorted { (one, two) -> Bool in
                return one.rating > two.rating
            }
        }
    }
}

struct Category: Identifiable, Codable, Hashable, Equatable {
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

class CategoryManager: ObservableObject {
    @Published var categories: [Category]
    @Published var selectedCategories: Set<UUID> = []
    @Published var newCategoryType: String = ""
    
    init(categories: [Category] = []) {
        self.categories = categories
        self.categories.removeAll(where: { $0 == .all })
    }
    
    func addCategory() {
        guard newCategoryType != "" else {
            return
        }
        let newCategory = Category(type: newCategoryType)
        categories.append(newCategory)
        selectedCategories.insert(newCategory.id)
        newCategoryType = ""
    }
    
    func toggleSelection(for category: Category) {
        if selectedCategories.contains(category.id) {
            selectedCategories.remove(category.id)
        } else {
            selectedCategories.insert(category.id)
        }
    }
    
    func getSelectedCategories() -> [Category] {
        return categories.filter { selectedCategories.contains($0.id) }
    }
}
