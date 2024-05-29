//
//   ProductDetail.swift
//   Decobliss
//
//   Created by @kinderBono on 27/05/2024.
//   

import SwiftUI

struct ProductDetail: View {
    @EnvironmentObject var appModel: AppModel
    @Environment(\.dismiss) var dismiss
    @StateObject var messageModel = MessagingModel()
    
    @Binding var product: Product
    @State var added: Bool = false
    @State var contactSeller: Bool = false
    @State var chatId: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.whitey.ignoresSafeArea()
                
                VStack {
                    if !product.images.isEmpty {
                        AsyncImage(url: URL(string: product.images[0])) { result in
                            switch result {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable().scaledToFill()
                                    .frame(height: 250).blendMode(.multiply)
                                    .clipped()
                            case .failure(_):
                                if product.images[0] != "" {
                                    Image(product.images[0])
                                        .resizable().scaledToFill()
                                        .frame(height: 250).blendMode(.multiply)
                                        .clipped()
                                } else {
                                    Placeholder(width: UIScreen.main.bounds.width, height: 250)
                                }
                            @unknown default:
                                fatalError()
                            }
                        }
                    }
                    
                    
                    VStack(spacing: 40) {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text(product.name)
                                    .multilineTextAlignment(.leading)
                                Spacer()
                                Text("\(product.price, format: .currency(code: "MYR"))")
                                    .lineLimit(1)
                            }
                            .font(.title2)
                            .bold()
                            
                            StarRating(rating: product.rating)
                        }
                        
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("Description")
                                        .font(.title3)
                                        .bold()
                                    Spacer()
                                }
                                Text(product.description)
                            }
                        }
                    }
                    .padding()
                    
                    HStack {
                        Button(action: {
                            addToCart()
                            added = true
                        }, label: {
                            ButtonLabel(text: "Add to Cart")
                        })
                        .disabled(!appModel.isLoggedIn)
                        .alert(isPresented: $added) {
                            Alert(title: Text("Success!"), message: Text("Product added to your cart."), dismissButton: .default(Text("OK"), action: {
                                dismiss()
                            }))
                        }
                        NavigationLink(destination: {
                            DisplayAR(name: product.name)
                        }, label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundStyle(.white)
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.blacky, lineWidth: 1)
                                Image(systemName: "arkit")
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
            .navigationBarBackButtonHidden()
            .toolbar {
                Toolbar(title: "Product Details")
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        initiateChat()
                    }, label: {
                        Label("Contact Seller", systemImage: "bubble.left.and.text.bubble.right")
                    })
                    .navigationDestination(isPresented: $contactSeller) {
                        ChatView(messageModel: messageModel, chatId: chatId)
                    }
                }
            }
        }
    }
    
    func addToCart() {
        appModel.dataManager.addToCart(cart: Cart(product: product))
    }
    
    func initiateChat() {
        guard let sellerId = product.seller else {
            return
        }
        let userId = appModel.dataManager.currentUser.authId
        
        messageModel.createChat(users: [userId, sellerId]) { result in
            switch result {
            case .success(let id):
                chatId = id
                contactSeller = true
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    ProductDetail(product: .constant(.init(name: "Item", price: 100, images: [""])))
        .environmentObject(AppModel())
}
