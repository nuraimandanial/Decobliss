//
//   Payment.swift
//   Decobliss
//
//   Created by @kinderBono on 26/05/2024.
//   

import Foundation

struct Payment: Identifiable, Codable, Hashable {
    var id = UUID()
    
    var name: String
    var image: String = ""
    var link: String = ""
}

extension Payment {
    static let payments = [creditCard, fpx, paypal]
    
    static let creditCard = Payment(name: "Credit Card", image: "mastercard")
    static let fpx = Payment(name: "Online Bank-In", image: "fpx")
    static let paypal = Payment(name: "PayPal", image: "paypal")
}
