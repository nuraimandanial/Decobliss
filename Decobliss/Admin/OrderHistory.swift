//
//   OrderHistory.swift
//   Decobliss
//
//   Created by @kinderBono on 28/05/2024.
//   

import SwiftUI

struct OrderHistory: View {
    @EnvironmentObject var appModel: AppModel
    
    @State var searchText: String = ""
    
    @State var orders: [Order] = []
    var filteredOrders: [Order] {
        if searchText.isEmpty {
            return orders
        } else {
            return orders.filter { order in
                order.name.lowercased().contains(searchText) || order.id.uuidString.lowercased().contains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.whitey.ignoresSafeArea()
                
                VStack {
                    Divider()
                    
                    VStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(.white)
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.blacky, lineWidth: 1)
                            HStack(spacing: 10) {
                                Image(systemName: "magnifyingglass")
                                TextField("Enter ID/Name", text: $searchText)
                            }
                            .padding()
                        }
                        .frame(height: 60)
                        .padding(.bottom)
                        
                        ScrollView(.vertical, showsIndicators: false) {
                            ForEach(filteredOrders) { order in
                                let total = order.carts.reduce(0) { $0 + $1.price }
                                NavigationLink(destination: {
                                    OrderDetails(order: Binding(get: {order}, set: {_ in}))
                                        .environmentObject(appModel)
                                }, label: {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 10)
                                            .foregroundStyle(.white)
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(.blacky, lineWidth: 1)
                                        HStack(spacing: 10) {
                                            Placeholder(width: 50, height: 50)
                                            VStack(alignment: .leading) {
                                                HStack {
                                                    Text(order.id.uuidString.prefix(6))
                                                        .font(.callout)
                                                        .italic()
                                                    Text("﹒")
                                                    Text(order.name)
                                                        .bold()
                                                }
                                                Text("\(total, format: .currency(code: "MYR"))")
                                            }
                                            Spacer()
                                            Text("\(order.carts.count) items")
                                        }
                                        .padding()
                                        .foregroundStyle(.blacky)
                                    }
                                    .padding(5)
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
                appModel.dataManager.fetchOrders(forSeller: appModel.dataManager.currentUser.authId) { orders in
                    self.orders = orders
                }
            }
            .toolbar {
                Toolbar(title: "Order History")
            }
        }
    }
}

#Preview {
    OrderHistory()
        .environmentObject(AppModel())
}
