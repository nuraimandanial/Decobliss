//
//   ChatView.swift
//   Decobliss
//
//   Created by @kinderBono on 27/05/2024.
//   

import SwiftUI

struct ChatView: View {
    @EnvironmentObject var appModel: AppModel
    @ObservedObject var messageModel: MessagingModel
    
    @State var name: String = ""
    @State var isLoading: Bool = true
    var chatId: String
    var userId: String {
        appModel.dataManager.currentUser.authId
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.whitey.ignoresSafeArea()
                
                if isLoading {
                    ProgressView("Loading...")
                        .padding()
                } else {
                    VStack {
                        Divider()
                        Text(name)
                            .font(.title3)
                            .bold()
                        Divider()
                        
                        ScrollViewReader { scroll in
                            ScrollView {
                                ForEach(messageModel.messages, id: \.self) { message in
                                    MessageRow(userId: userId, message: message)
                                }
                                .padding()
                            }
                        }
                        
                        HStack(spacing: 10) {
                            TextBox(hint: "Send a new message...", text: $messageModel.newMessage)
                                .onSubmit {
                                    sendMessage()
                                }
                            Button(action: {
                                sendMessage()
                            }, label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.blacky, lineWidth: 1)
                                    Image(systemName: "paperplane")
                                        .imageScale(.large)
                                        .foregroundStyle(.blacky)
                                }
                                .frame(width: 60, height: 60)
                            })
                        }
                        .padding()
                    }
                    .padding(.top)
                }
            }
            .navigationBarBackButtonHidden()
            .task {
                messageModel.subscribeToChat(chatId: chatId)
                fetchName()
            }
            .toolbar {
                Toolbar(title: "Chat Box")
            }
        }
    }
    
    func sendMessage() {
        messageModel.sendMessage(chatId: chatId)
    }
    
    func fetchName() {
        messageModel.fetchOtherName(for: chatId, excluding: userId) { result in
            switch result {
            case .success(let name):
                self.name = name
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        isLoading = false
    }
}

#Preview {
    ChatView(messageModel: MessagingModel(), chatId: "72CD8FBE-8572-47AB-BF63-041CBF755B1C")
        .environmentObject(AppModel())
}

struct MessageRow: View {
    var userId: String
    var message: Message
    
    var body: some View {
        HStack {
            if message.senderId == userId {
                Spacer()
                VStack(alignment: .trailing, spacing: 5) {
                    Text(message.content)
                    Text(message.time)
                        .font(.caption2)
                }
                .padding(10)
                .background(Color.yellows)
                .foregroundStyle(.blacky)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            } else {
                VStack(alignment: .trailing, spacing: 5) {
                    Text(message.content)
                    Text(message.time)
                        .font(.caption2)
                }
                .padding(10)
                .background(Color.gray)
                .foregroundStyle(.whitey)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                Spacer()
            }
        }
    }
}
