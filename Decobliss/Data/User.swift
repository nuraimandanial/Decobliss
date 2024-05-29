//
//   User.swift
//   Decobliss
//
//   Created by @kinderBono on 26/05/2024.
//   

import Foundation
import CoreLocation

struct User: Identifiable, Codable, Hashable {
    var id: UUID {
        profile.id
    }
    
    var authId: String = ""
    var profile = Profile()
    var address: [Address] = []
    var carts: [Cart] = []
    var chats: [UUID : Chat] = [:]
    
    var points: Int = 100
    
    var isSeller: Bool = false
}

extension User {
    
}

struct Profile: Identifiable, Codable, Hashable {
    var id = UUID()
    
    var username: String = ""
    var email: String = ""
    var password: Int = 0
    
    var details = Details()
}

struct Details: Codable, Hashable {
    var image: String = "user"
    var firstName: String = ""
    var lastName: String = ""
    var phone: String = ""
}

struct Address: Identifiable, Codable, Hashable {
    var id = UUID()
    
    var type: String = ""
    var name: String = ""
    var phone: String = ""
    var address: String = ""
    var postcode: String = ""
    var state: String = ""
    var block: String = ""
    
    var latitude: Double = 0
    var longitude: Double = 0
    
    mutating func setCoord(completion: @escaping (Address) -> Void) {
        var uSelf = self
        
        let geocoder = CLGeocoder()
        let address = "\(self.address), \(self.postcode) \(self.state), Malaysia"
        
        geocoder.geocodeAddressString(address) { placemark, error in
            defer {
                completion(uSelf)
            }
            
            guard let placemark = placemark?.first, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            uSelf.latitude = placemark.location?.coordinate.latitude ?? 0.0
            uSelf.longitude = placemark.location?.coordinate.longitude ?? 0.0
        }
    }
}

extension Address {
    func distance(to destination: Address) -> CLLocationDistance {
        let start = CLLocation(latitude: destination.latitude, longitude: destination.longitude)
        let end = CLLocation(latitude: latitude, longitude: longitude)
        return start.distance(from: end)
    }
}
