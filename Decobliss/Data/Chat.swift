//
//   Chat.swift
//   Decobliss
//
//   Created by @kinderBono on 26/05/2024.
//   

import Foundation
import FirebaseFirestore
import Combine

class MessagingModel: ObservableObject {
    @Published var userId: String = ""
    
    @Published var chats: [Chat] = []
    @Published var messages: [Message] = []
    @Published var newMessage: String = ""
    @Published var userNames: [String: String] = [:]
    
    private var firebaseService = FirebaseService()
    private var chatService = ChatService()
    private var cancellables: Set<AnyCancellable> = []
    
    func fetchChats(userId: String) {
        self.userId = userId
        
        guard userId != "" else { return }
        chatService.fetchChats(for: userId) { result in
            switch result {
            case .success(let chats):
                self.chats = chats
                self.fetchName(for: chats)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchName(for chats: [Chat]) {
        let userIds = Set(chats.flatMap { $0.users })
        for userId in userIds {
            firebaseService.fetchName(userId: userId) { result in
                switch result {
                case .success(let name):
                    self.userNames[userId] = name
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func fetchOtherName(for chatId: String, excluding userId: String, completion: @escaping (Result<String, Error>) -> Void) {
        chatService.fetchChat(by: chatId) { result in
            switch result {
            case .success(let chat):
                let otherId = chat.users.first { $0 != userId } ?? ""
                completion(.success(self.userNames[otherId] ?? "User"))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func subscribeToChat(chatId: String) {
        chatService.subscribeToChat(chatId: chatId) { result in
            switch result {
            case .success(let chat):
                self.messages = chat.messages
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func sendMessage(chatId: String) {
        guard userId != "" else { return }
        let message = Message(senderId: userId, content: newMessage, timestamp: Date())
        chatService.sendMessage(chatId: chatId, message: message) { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.newMessage = ""
            }
        }
    }
    
    func createChat(users: [String], completion: @escaping (Result<String, Error>) -> Void) {
        chatService.createChat(users: users) { result in
            switch result {
            case .success(let chatId):
                self.fetchChats(userId: self.userId)
                completion(.success(chatId))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

class ChatService {
    private let db = Firestore.firestore()
    
    func createChat(users: [String], completion: @escaping (Result<String, Error>) -> Void) {
        let chat = Chat(users: users, messages: [])
        do {
            let ref = try db.collection("chats").addDocument(from: chat)
            completion(.success(ref.documentID))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func sendMessage(chatId: String, message: Message, completion: @escaping (Error?) -> Void) {
        let messageData: [String: Any] = [
            "content": message.content,
            "sender_id": message.senderId,
            "timestamp": message.timestamp
        ]
        db.collection("chats").document(chatId).updateData([
            "messages": FieldValue.arrayUnion([messageData])
        ]) { error in
            completion(error)
        }
    }
    
    func subscribeToChat(chatId: String, completion: @escaping (Result<Chat, Error>) -> Void) {
        db.collection("chats").document(chatId).addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                completion(.failure(error!))
                return
            }
            do {
                let chat = try document.data(as: Chat.self)
                completion(.success(chat))
            } catch let error {
                completion(.failure(error))
            }
        }
    }
    
    func fetchChats(for userId: String, completion: @escaping (Result<[Chat], Error>) -> Void) {
        db.collection("chats").whereField("users", arrayContains: userId).getDocuments { (querySnaphot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            let chats = querySnaphot?.documents.compactMap { document in
                try? document.data(as: Chat.self)
            } ?? []
            completion(.success(chats))
        }
    }
    
    func fetchChat(by chatId: String, completion: @escaping (Result<Chat, Error>) -> Void) {
        db.collection("chats").document(chatId).getDocument { document, error in
            if let document = document, document.exists {
                do {
                    let chat = try document.data(as: Chat.self)
                    completion(.success(chat))
                } catch {
                    completion(.failure(NSError(domain: "Chat Data Missing", code: 404, userInfo: nil)))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
}

struct Chat: Identifiable, Codable, Hashable {
    @DocumentID var id: String? = UUID().uuidString
    
    var users: [String]
    var messages: [Message]
    
    enum CodingKeys: String, CodingKey {
        case id
        case users
        case messages
    }
}

struct Message: Identifiable, Codable, Hashable {
    @DocumentID var id: String? = UUID().uuidString
    
    var senderId: String
    var content: String
    var timestamp: Date
    
    var date: String {
        timestamp.formatted(date: .abbreviated, time: .omitted)
    }
    var time: String {
        timestamp.formatted(date: .omitted, time: .shortened)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case senderId = "sender_id"
        case content
        case timestamp
    }
}

let chat1 = Chat(
    users: ["user1ID", "user2ID"],
    messages: [
        Message(
            senderId: "user1ID",
            content: "Hi, how are you?",
            timestamp: Date(timeIntervalSinceNow: -3600)
        ),
        Message(
            senderId: "user2ID",
            content: "I'm good, thanks! How about you?",
            timestamp: Date(timeIntervalSinceNow: -1800)
        ),
        Message(
            senderId: "user1ID",
            content: "Doing well, thanks for asking!",
            timestamp: Date(timeIntervalSinceNow: -1200)
        )
    ]
)

let chat2 = Chat(
    users: ["user3ID", "user4ID"],
    messages: [
        Message(
            senderId: "user3ID",
            content: "Hey, did you finish the report?",
            timestamp: Date(timeIntervalSinceNow: -7200)
        ),
        Message(
            senderId: "user4ID",
            content: "Yes, I sent it to you via email.",
            timestamp: Date(timeIntervalSinceNow: -3600)
        ),
        Message(
            senderId: "user3ID",
            content: "Great, thanks! I'll review it tonight.",
            timestamp: Date(timeIntervalSinceNow: -1800)
        )
    ]
)
