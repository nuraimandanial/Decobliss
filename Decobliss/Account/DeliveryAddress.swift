//
//   DeliveryAddress.swift
//   Decobliss
//
//   Created by @kinderBono on 27/05/2024.
//   

import SwiftUI

struct DeliveryAddress: View {
    @EnvironmentObject var appModel: AppModel
    @Environment(\.dismiss) var dismiss
    
    @State var addresses: [Address] = []
    
    @State var alert: Bool = false
    @State var delete: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.whitey.ignoresSafeArea()
                
                VStack {
                    Divider()
                    
                    VStack {
                        ScrollView {
                            ForEach(appModel.dataManager.currentUser.address) { address in
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundStyle(.white)
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.blacky, lineWidth: 1)
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text(address.name)
                                            Divider().frame(height: 20)
                                            Text(address.phone)
                                            Spacer()
                                        }
                                        HStack {
                                            if address.block != "" {
                                                Text("\(address.block), ")
                                            }
                                            Text(address.address)
                                                .lineLimit(1)
                                        }
                                        HStack {
                                            Text(address.postcode)
                                            Text(address.state)
                                        }
                                    }
                                    .padding()
                                    HStack {
                                        Spacer()
                                        VStack {
                                            NavigationLink(destination: {
                                                
                                            }, label: {
                                                Image(systemName: "square.and.pencil")
                                                    .foregroundStyle(.yellows)
                                            })
                                            Spacer()
                                            Button(action: {
                                                alert = true
                                            }, label: {
                                                Image(systemName: "trash")
                                                    .foregroundStyle(.red)
                                            })
                                            .alert(isPresented: $alert) {
                                                Alert(title: Text("Are you sure?"), message: Text("Confirm to delete this address."), primaryButton: .cancel(), secondaryButton: .destructive(Text("Delete"), action: {
                                                    appModel.dataManager.deleteAddress(of: address)
                                                }))
                                            }
                                            .alert(isPresented: $delete) {
                                                Alert(title: Text("Success"), message: Text("Address deleted from user data."), dismissButton: .default(Text("OK")))
                                            }
                                        }
                                    }
                                    .padding()
                                }
                                .frame(height: 100)
                                .padding(5)
                            }
                        }
                        
                        NavigationLink(destination: {
                            AddAddress()
                                .environmentObject(appModel)
                        }, label: {
                            ButtonLabel(text: "Add New Address")
                                .padding(.horizontal, 40)
                        })
                    }
                    .padding()
                }
                .padding(.top)
            }
            .navigationBarBackButtonHidden()
            .toolbar {
                Toolbar(title: "My Address")
            }
            .task {
                addresses = appModel.dataManager.currentUser.address
            }
        }
    }
}

#Preview {
    DeliveryAddress()
        .environmentObject(AppModel())
}
