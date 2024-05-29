//
//   DataManager.swift
//   Decobliss
//
//   Created by @kinderBono on 26/05/2024.
//   

import Foundation
import SwiftUI

class DataManager: ObservableObject {
    private var firebaseService = FirebaseService()
    private var authManager = AuthManager()
    
    @Published var currentUser: User = User() {
        didSet {
            saveCurrentUser()
        }
    }
    
    private let userDefaults = UserDefaults.standard
    private let currentUserKey = "currentUserKey"
    
    init() {
        loadCurrentUser()
        fetchProducts()
    }
    
    public func saveCurrentUser() {
        do {
            let encodedData = try JSONEncoder().encode(currentUser)
            userDefaults.set(encodedData, forKey: currentUserKey)
            authManager.refreshIdToken()
        } catch {
            print("Error Encoding Current User: \(error)")
        }
    }
    
    private func loadCurrentUser() {
        guard let savedData = userDefaults.data(forKey: currentUserKey) else {
            return
        }
        
        do {
            let loadedUser = try JSONDecoder().decode(User.self, from: savedData)
            currentUser = loadedUser
            authManager.refreshIdToken()
        } catch {
            print("Error Decoding Current User: \(error)")
        }
    }
    
    func updateProfile(with profile: Profile, completion: @escaping (Error?) -> Void) {
        let uid = currentUser.authId
        
        currentUser.profile = profile
        
        guard let userData = try? JSONEncoder().encode(currentUser), let jsonObject = try? JSONSerialization.jsonObject(with: userData), let jsonDict = jsonObject as? [String: Any] else {
            completion(NSError(domain: "Error Encoding User Data", code: 0, userInfo: nil))
            return
        }
        
        firebaseService.saveUser(userId: uid, userJson: jsonDict) { error in
            completion(error)
        }
    }
    
    func updatePassword(currentPassword: String, newPassword: String, completion: @escaping (Error?) -> Void) {
        authManager.reauntheticate(currentPassword: currentPassword) { [self] error in
            if let error = error {
                completion(error)
            } else {
                authManager.updatePassword(newPassword: newPassword) { error in
                    completion(error)
                }
                currentUser.profile.password = newPassword.count
                saveUser()
            }
        }
    }
    
    func saveUser() {
        let userId = currentUser.authId
        
        guard let userData = try? JSONEncoder().encode(currentUser), let jsonObject = try? JSONSerialization.jsonObject(with: userData), let jsonDict = jsonObject as? [String: Any] else {
            return
        }
        
        firebaseService.saveUser(userId: userId, userJson: jsonDict) { _ in }
        saveCurrentUser()
    }
    
    func addAddress(with address: Address) {
        currentUser.address.append(address)
        saveUser()
    }
    
    func deleteAddress(of address: Address) {
        currentUser.address.removeAll(where: { $0.id == address.id })
        saveUser()
    }
    
    func addToCart(cart: Cart) {
        currentUser.carts.append(cart)
        saveUser()
    }
    
    func removeProductFromCart(id: UUID) {
        guard let cart = currentUser.carts.first(where: { $0.id == id }) else {
            return
        }
        currentUser.carts.removeAll(where: { $0.id == cart.id })
        saveUser()
    }
    
    func calcShipping(buyer: Address, seller: Address) -> Float {
        let baseFee: Float = 0.5
        let distance = seller.distance(to: buyer) / 1000
        
        return baseFee * Float(distance)
    }
    
    @Published var products: [UUID: Product] = [:]
    @Published var categories: [Category] = Category.allCategory
    
    func fetchProducts() {
        firebaseService.fetchProducts { result in
            switch result {
            case .success(let products):
                for product in products {
                    self.products[product.id] = product
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func addProduct(_ product: Product, imageDatas: [Data], completion: @escaping (Error?) -> Void) {
        let group = DispatchGroup()
        var urls = [String]()
        
        for data in imageDatas {
            group.enter()
            firebaseService.uploadImage(sellerId: currentUser.authId, productName: product.name, imageData: data) { result in
                defer { group.leave() }
                switch result {
                case .success(let url):
                    urls.append(url)
                case .failure(let error):
                    completion(error)
                }
            }
        }
        
        var product = product
        group.notify(queue: .main) { [self] in
            product.images = urls
            product.seller = currentUser.authId
            
            products[product.id] = product
            firebaseService.saveProduct(product, completion: completion)
        }
    }
    
    func removeProduct(productId: UUID) {
        products.removeValue(forKey: productId)
    }
    
    func allProducts() -> [Product] {
        return Array(products.values)
    }
    
    func productsForSeller(sellerId: String) -> [Product] {
        return products.values.filter { $0.seller == sellerId }
    }
    
    @Published var orders: [Order] = []
    
    func saveOrder(_ order: Order, completion: @escaping (Error?) -> Void) {
        firebaseService.saveOrder(order) { error in
            if let error = error {
                completion(error)
            } else {
                self.orders.append(order)
            }
        }
    }
    
    func fetchOrders(forSeller sellerId: String, completion: @escaping ([Order]) -> Void) {
        firebaseService.fetchOrders(forSeller: sellerId) { result in
            switch result {
            case .success(let orders):
                self.orders = orders
                completion(orders)
            case .failure(let error):
                print(error.localizedDescription)
                completion([])
            }
        }
    }
}
