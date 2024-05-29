//
//   OrderDetails.swift
//   Decobliss
//
//   Created by @kinderBono on 28/05/2024.
//   

import SwiftUI

struct OrderDetails: View {
    @EnvironmentObject var appModel: AppModel
    @StateObject var messageModel = MessagingModel()
    
    @Binding var order: Order
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.whitey.ignoresSafeArea()
                
                VStack(spacing: 40) {
                    HStack {
                        Text(order.id.uuidString.prefix(6))
                            .font(.callout)
                            .italic()
                        Text("﹒")
                        Text(order.name)
                            .bold()
                    }
                    VStack(spacing: 20) {
                        VStack {
                            HStack {
                                Text("Payment")
                                    .bold()
                                Spacer()
                            }
                            displayBox(text: "\(order.payment.name)")
                        }
                        VStack {
                            HStack {
                                Text("Type")
                                    .bold()
                                Spacer()
                            }
                            displayBox(text: "\(order.shippingType.rawValue())")
                        }
                        VStack {
                            HStack {
                                Text("Status")
                                    .bold()
                                Spacer()
                            }
                            displayBox(text: "\(order.status.rawValue())")
                        }
                        VStack {
                            HStack {
                                Text("Total")
                                    .bold()
                                Spacer()
                            }
                            displayBox(text: "RM " + String(format: "%.2f", order.carts.reduce(0) { $0 + $1.price }))
                        }
                        VStack {
                            HStack {
                                Text("Action")
                                    .bold()
                                Spacer()
                            }
                            HStack(spacing: 10) {
                                Button(action: {
                                    
                                }, label: {
                                    ButtonLabel(text: "Refund", color: .red)
                                })
                                NavigationLink(destination: {
                                    InboxView(messageModel: messageModel)
                                        .environmentObject(appModel)
                                }, label: {
                                    ButtonLabel(text: "Message")
                                })
                            }
                        }
                    }
                    .padding(.horizontal, 40)
                }
                .padding()
            }
            .navigationBarBackButtonHidden()
            .toolbar {
                Toolbar(title: "Order History")
            }
        }
    }
    
    @ViewBuilder
    func displayBox(text: String) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.white)
            RoundedRectangle(cornerRadius: 10)
                .stroke(.blacky, lineWidth: 1)
            HStack {
                Text(text)
                Spacer()
            }
            .padding()
        }
        .frame(height: 50)
    }
}

#Preview {
    OrderDetails(order: .constant(.init(name: "Ara", userId: "", carts: [.init(product: .init(name: "Z", price: 12)), .init(product: .init(name: "Y", price: 75.3))], deliveryAddress: .init(), shippingType: .doorStep, shippingTotal: 15, payment: .paypal, sellerId: "")))
        .environmentObject(AppModel())
}
