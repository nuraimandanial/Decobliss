//
//   Chat.swift
//   Decobliss
//
//   Created by @kinderBono on 26/05/2024.
//   

import Foundation

struct Chat: Identifiable, Codable, Hashable {
    var id = UUID()
    
    var participants: [UUID] = []
    var messages: [Message] = []
    
    mutating func sendMessage(_ message: Message) {
        messages.append(message)
    }
}

struct Message: Identifiable, Codable, Hashable {
    var id = UUID()
    
    var sender: String
    var text: String
    var dateTime = Date()
    
    var date: String {
        dateTime.formatted(date: .abbreviated, time: .omitted)
    }
    var time: String {
        dateTime.formatted(date: .omitted, time: .shortened)
    }
}
