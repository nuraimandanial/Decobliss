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
                    var user = try JSONDecoder().decode(User.self, from: jsonData)
                    completion(.success(user))
                } catch {
                    completion(.failure(error))
                }
            } else {
                completion(.failure(NSError(domain: "No User Data Found", code: 404, userInfo: nil)))
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
}
