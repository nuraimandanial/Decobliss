//
//   FirebaseService.swift
//   Decobliss
//
//   Created by @kinderBono on 26/05/2024.
//   

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseStorage
import Combine

class FirebaseService {
    private var db = Firestore.firestore()
    private var storage = Storage.storage()
    
    
    // User
    func saveUser(userId: String, userJson: [String: Any], completion: @escaping (Error?) -> Void) {
        db.collection("users").document(userId).setData(userJson) { error in
            completion(error)
        }
    }
    
    func fetchUser(userId: String, completion: @escaping (Result<User, Error>) -> Void) {
        db.collection("users").document(userId).getDocument { document, error in
            if let error = error {
                completion(.failure(error))
                return
            } else if let document = document, document.exists, let data = document.data() {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                    let user = try JSONDecoder().decode(User.self, from: jsonData)
                    completion(.success(user))
                } catch {
                    completion(.failure(error))
                }
            } else {
                completion(.failure(NSError(domain: "No User Data Found", code: 404, userInfo: nil)))
            }
        }
    }
    
    func fetchName(userId: String, completion: @escaping (Result<String, Error>) -> Void) {
        db.collection("users").document(userId).getDocument { document, error in
            if let document = document, document.exists {
                if let profile = document.data()?["profile"] as? [String: Any], let details = profile["details"] as? [String: Any], let name = details["firstName"] as? String {
                    completion(.success(name))
                } else {
                    completion(.failure(NSError(domain: "No Name Field", code: 404, userInfo: nil)))
                }
            } else {
                completion(.failure(error ?? NSError(domain: "No User Data Found", code: 404, userInfo: nil)))
            }
        }
    }
    
    func deleteUser(userId: String, completion: @escaping (Error?) -> Void) {
        db.collection("users").document(userId).delete { error in
            completion(error)
        }
    }
    
    func deleteUserStorage(userId: String, completion: @escaping (Error?) -> Void) {
        let storageRef = storage.reference().child(userId)
        
        storageRef.listAll { (result, error) in
            guard let result = result else {
                completion(NSError(domain: "Error Getting Storage List", code: 0, userInfo: nil))
                return
            }
            if let error = error {
                completion(error)
                return
            }
            
            let deleteGroup = DispatchGroup()
            for item in result.items {
                deleteGroup.enter()
                item.delete { error in
                    if let error = error {
                        completion(error)
                        return
                    }
                    deleteGroup.leave()
                }
            }
            
            for prefix in result.prefixes {
                deleteGroup.enter()
                prefix.delete { error in
                    if let error = error{
                        completion(error)
                        return
                    }
                    deleteGroup.leave()
                }
            }
            
            deleteGroup.notify(queue: .main) {
                completion(nil)
            }
        }
    }
    
    // Product
    func saveProduct(_ product: Product, completion: @escaping (Error?) -> Void) {
        do {
            let jsonData = try JSONEncoder().encode(product)
            let jsonObject = try JSONSerialization.jsonObject(with: jsonData)
            
            guard let jsonDict = jsonObject as? [String: Any] else {
                completion(NSError(domain: "Error Encoding Product", code: 0, userInfo: nil))
                return
            }
            db.collection("products").document(product.id.uuidString).setData(jsonDict) { error in
                completion(error)
            }
        } catch {
            completion(error)
        }
    }
    
    func uploadImage(sellerId: String, productName: String, imageData: Data, completion: @escaping (Result<String, Error>) -> Void) {
        let ref = storage.reference()
        let imageId = UUID().uuidString
        let imageRef = ref.child("products/\(sellerId)/\(productName)/\(imageId).jpg")
        
        imageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            imageRef.downloadURL { url, error in
                if let url = url {
                    completion(.success(url.absoluteString))
                } else {
                    completion(.failure(error ?? NSError(domain: "Unknown Error", code: -1, userInfo: nil)))
                }
            }
        }
    }
    
    func fetchProducts(completion: @escaping (Result<[Product], Error>) -> Void) {
        db.collection("products").getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            let products = querySnapshot?.documents.compactMap { document -> Product? in
                try? document.data(as: Product.self)
            } ?? []
            
            completion(.success(products))
        }
    }
    
    func deleteProduct(productId: UUID, completion: @escaping (Error?) -> Void) {
        db.collection("products").document(productId.uuidString).delete { error in
            completion(error)
        }
    }
    
    func saveOrder(_ order: Order, completion: @escaping (Error?) -> Void) {
        do {
            let jsonData = try JSONEncoder().encode(order)
            let jsonObject = try JSONSerialization.jsonObject(with: jsonData)
            
            guard let jsonDict = jsonObject as? [String: Any] else {
                completion(NSError(domain: "Error Encoding Order", code: 0, userInfo: nil))
                return
            }
            db.collection("orders").document(order.id.uuidString).setData(jsonDict) { error in
                completion(error)
            }
        } catch {
            completion(error)
        }
    }
    
    func fetchOrders(forSeller sellerId: String, completion: @escaping (Result<[Order], Error>) -> Void) {
        db.collection("orders").whereField("sellerId", isEqualTo: sellerId).getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            let orders = querySnapshot?.documents.compactMap { document -> Order? in
                try? document.data(as: Order.self)
            } ?? []
            
            completion(.success(orders))
        }
    }
}
