//
//   CartView.swift
//   Decobliss
//
//   Created by @kinderBono on 27/05/2024.
//   

import SwiftUI

struct CartView: View {
    @EnvironmentObject var appModel: AppModel
    
    @State var carts: [Cart] = []
    var totalPrice: Float {
        return carts.reduce(0) { $0 + $1.price }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.whitey.ignoresSafeArea()
                
                VStack {
                    Divider()
                    VStack {
                        if !carts.isEmpty {
                            ScrollView(.vertical, showsIndicators: false) {
                                ForEach($appModel.dataManager.currentUser.carts) { $cart in
                                    let product = cart.product
                                    
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 10)
                                            .foregroundStyle(.white)
                                        HStack {
                                            if !product.images.isEmpty {
                                                AsyncImage(url: URL(string: product.images[0])) { result in
                                                    switch result {
                                                    case .empty:
                                                        ProgressView()
                                                    case .success(let image):
                                                        image
                                                            .resizable().scaledToFill()
                                                            .frame(width: 100, height: 100)
                                                            .clipShape(LeftRoundedRectangle(radius: 10))
                                                    case .failure(_):
                                                        if product.images[0] != "" {
                                                            Image(product.images[0])
                                                                .resizable().scaledToFill()
                                                                .frame(width: 100, height: 100)
                                                                .clipShape(LeftRoundedRectangle(radius: 10))
                                                        } else {
                                                            Placeholder(width: 100, height: 100)
                                                        }
                                                    @unknown default:
                                                        fatalError()
                                                    }
                                                }
                                            }
                                            VStack(alignment: .leading) {
                                                Text(product.name)
                                                    .bold()
                                                    .lineLimit(2)
                                                Text("RM \(cart.price, specifier: "%.2f")")
                                                HStack {
                                                    Spacer()
                                                    Button(action: {
                                                        if cart.quantity > 1 {
                                                            cart.quantity -= 1
                                                        } else {
                                                            appModel.dataManager.removeProductFromCart(id: cart.id)
                                                        }
                                                    }, label: {
                                                        Image(systemName: "minus.circle")
                                                    })
                                                    Text(String(cart.quantity))
                                                    Button(action: {
                                                        cart.quantity += 1
                                                    }, label: {
                                                        Image(systemName: "plus.circle")
                                                    })
                                                    Spacer()
                                                }
                                            }
                                            .padding()
                                            Spacer()
                                        }
                                        VStack {
                                            HStack {
                                                Spacer()
                                                Button(action: {
                                                    appModel.dataManager.removeProductFromCart(id: cart.id)
                                                }, label: {
                                                    Image(systemName: "xmark.circle.fill")
                                                        .foregroundStyle(.red)
                                                })
                                            }
                                            Spacer()
                                        }
                                        .padding(10)
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(.blacky, lineWidth: 1)
                                    }
                                    .padding(5)
                                }
                            }
                            .padding([.horizontal, .top])
                        } else {
                            Spacer()
                            Text("Your cart is empty")
                            Spacer()
                        }
                        
                        Divider()
                        
                        VStack {
                            Text("Order Summary")
                                .bold()
                            
                            Divider()
                            
                            HStack {
                                Text("\(carts.count) items")
                                Spacer()
                                Text("RM \(totalPrice, specifier: "%.2f")")
                                    .bold()
                            }
                            .padding()
                            
                            VStack {
                                NavigationLink(destination: {
                                    CheckoutView()
                                        .environmentObject(appModel)
                                }, label: {
                                    ButtonLabel(text: "Check Out")
                                })
                                .disabled(carts.isEmpty)
                                Button(action: {
                                    appModel.selectedTab = 0
                                }, label: {
                                    ButtonLabel(text: "Continue Shopping")
                                })
                            }
                            .padding(.horizontal, 40)
                            .padding(.bottom)
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationBarBackButtonHidden()
            .task {
                carts = appModel.dataManager.currentUser.carts
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Shopping Cart")
                        .font(.title2)
                        .bold()
                }
            }
        }
    }
}

#Preview {
    CartView()
        .environmentObject(AppModel())
}
