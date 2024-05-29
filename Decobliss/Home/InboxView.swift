//
//   InboxView.swift
//   Decobliss
//
//   Created by @kinderBono on 27/05/2024.
//   

import SwiftUI

struct InboxView: View {
    @EnvironmentObject var appModel: AppModel
    @StateObject var messageModel = MessagingModel()
    
    var userId: String {
        appModel.dataManager.currentUser.authId
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.whitey.ignoresSafeArea()
                
                VStack {
                    Divider()
                    
                    VStack {
                        ScrollView(.vertical, showsIndicators: false) {
                            ForEach(messageModel.chats) { chat in
                                NavigationLink(destination: {
                                    ChatView(messageModel: messageModel, chatId: chat.id ?? "")
                                }, label: {
                                    InboxRow(userId: userId, chat: chat, users: messageModel.userNames)
                                })
                            }
                        }
                    }
                    .padding([.horizontal, .top])
                }
                .padding(.top)
            }
            .navigationBarBackButtonHidden()
            .task {
                messageModel.fetchChats(userId: userId)
            }
            .toolbar {
                Toolbar(title: "Inbox")
            }
        }
    }
}

#Preview {
    InboxView()
        .environmentObject(AppModel())
}

struct InboxRow: View {
    var userId: String
    var chat: Chat
    var users: [String: String]
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.white)
            RoundedRectangle(cornerRadius: 10)
                .stroke(.blacky, lineWidth: 1)
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(getName())
                        .font(.headline)
                        .bold()
                    if let lastMessage = chat.messages.last {
                        Text(lastMessage.content)
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                    } else {
                        Text("No messages...")
                    }
                }
                Spacer()
            }
            .padding()
            .foregroundStyle(.blacky)
        }
        .padding(2)
        .frame(height: 80)
    }
    
    private func getName() -> String {
        guard userId != "" else { return "Unknown" }
        let otherId = chat.users.first { $0 != userId } ?? "Unknown"
        return users[otherId] ?? "User"
    }
}
