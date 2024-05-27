//
//   CheckoutView.swift
//   Decobliss
//
//   Created by @kinderBono on 27/05/2024.
//   

import SwiftUI

struct CheckoutView: View {
    @EnvironmentObject var appModel: AppModel
    @Environment(\.dismiss) var dismiss
    
    let shippingOption = Shipping.options
    @State var selectShipping: ShippingType = .selfPickup
    @State var shippingIndex: Int?
    
    @State var selectedAddress: Address = .init()
    
    @State var paymentMethods: [Payment] = Payment.payments
    @State var selectedPayment: Payment = .init(name: "")
    @State var paymentIndex: Int = 0
    
    var shippingFee: Float {
        if selectShipping == .doorStep {
            return 15
        } else {
            return 0
        }
    }
    
    var subTotal: Float {
        return appModel.dataManager.currentUser.carts.reduce(0) { $0 + $1.price }
    }
    
    var total: Float {
        shippingFee + subTotal
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.whitey.ignoresSafeArea()
                
                VStack {
                    Divider()
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack {
                            HStack {
                                Text("Shipping Option")
                                    .font(.title2)
                                    .bold()
                                Spacer()
                            }
                            ScrollView(.vertical, showsIndicators: false) {
                                ForEach(shippingOption.indices, id: \.self) { index in
                                    let option = shippingOption[index]
                                    
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 10)
                                            .foregroundStyle(.white)
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(.black, lineWidth: 1)
                                        HStack(spacing: 10) {
                                            SelectionButton(selection: Binding(get: {shippingIndex == index}, set: { selected in
                                                if selected {
                                                    shippingIndex = index
                                                    selectShipping = option.type
                                                }
                                            }))
                                            Text(option.name)
                                            Spacer()
                                            if option.type == .doorStep && selectShipping == .doorStep {
                                                NavigationLink(destination: {
                                                    SelectAddress(selectedAddress: Binding(get: {selectedAddress}, set: { address in
                                                        selectedAddress = address
                                                    }))
                                                        .environmentObject(appModel)
                                                }, label: {
                                                    Image(systemName: "chevron.right")
                                                })
                                            }
                                        }
                                        .padding()
                                    }
                                    .padding(5)
                                }
                            }
                        }
                        .padding([.horizontal, .top])
                        
                        VStack {
                            HStack {
                                Text("Payment Method")
                                    .font(.title2)
                                    .bold()
                                Spacer()
                            }
                            ScrollView(.vertical, showsIndicators: false) {
                                ForEach(paymentMethods.indices, id: \.self) { index in
                                    let payment = paymentMethods[index]
                                    
                                    HStack(spacing: 10) {
                                        if payment.image != "" {
                                            Image(payment.image)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 50, height: 50)
                                        } else {
                                            Spacer().frame(width: 50)
                                        }
                                        Text(payment.name)
                                        Spacer()
                                        SelectionButton(selection: Binding(get: {paymentIndex == index}, set: { selected in
                                            if selected {
                                                paymentIndex = index
                                                selectedPayment = payment
                                            }
                                        }))
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                        .padding()
                        
                        Divider()
                        
                        VStack {
                            HStack {
                                Text("Shipping Fee")
                                Spacer()
                                Text("RM \(shippingFee, specifier: "%.2f")")
                            }
                            HStack {
                                Text("Subtotal")
                                Spacer()
                                Text("RM \(subTotal, specifier: "%.2f")")
                            }
                            HStack {
                                Text("Total")
                                Spacer()
                                Text("RM \(total, specifier: "%.2f")")
                                    .bold()
                            }
                            NavigationLink(destination: {
                                PaymentDone()
                                    .environmentObject(appModel)
                            }, label: {
                                ButtonLabel(text: "Pay Now")
                                    .padding(.horizontal, 40)
                            })
                        }
                        .padding()
                    }
                }
                .padding(.top)
            }
            .navigationBarBackButtonHidden()
            .toolbar {
                Toolbar(title: "Checkout")
            }
        }
    }
}

#Preview {
    CheckoutView()
        .environmentObject(AppModel())
}
