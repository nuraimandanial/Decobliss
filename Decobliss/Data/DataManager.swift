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
    
    @Published var categories: [Category] = Category.allCategory
    
    private let userDefaults = UserDefaults.standard
    private let currentUserKey = "currentUserKey"
    
    init() {
        loadCurrentUser()
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
}
