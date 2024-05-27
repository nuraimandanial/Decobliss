//
//   SelectAddress.swift
//   Decobliss
//
//   Created by @kinderBono on 27/05/2024.
//   

import SwiftUI

struct SelectAddress: View {
    @EnvironmentObject var appModel: AppModel
    
    @State var deliveryAddress: [Address] = []
    @Binding var selectedAddress: Address
    @State var addressIndex: Int?
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.whitey.ignoresSafeArea()
                
                VStack {
                    Divider()
                    
                    VStack {
                        if !deliveryAddress.isEmpty {
                            ForEach(deliveryAddress.indices, id: \.self) { index in
                                let address = deliveryAddress[index]
                                
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundStyle(.white)
                                    HStack(spacing: 15) {
                                        SelectionButton(selection: Binding(get: { addressIndex == index }, set: { selected in
                                            if selected {
                                                addressIndex = index
                                                selectedAddress = address
                                            } else {
                                                addressIndex = nil
                                            }
                                        }))
                                        VStack(alignment: .leading, spacing: 0) {
                                            if address.type != "" {
                                                Text(address.type)
                                                    .bold()
                                            }
                                            HStack {
                                                Text(address.name)
                                                Divider().frame(height: 20)
                                                Text(address.phone)
                                                Spacer()
                                            }
                                            HStack {
                                                if address.block != "" {
                                                    Text(address.block + ", ")
                                                }
                                                Text(address.address)
                                                    .lineLimit(1)
                                            }
                                            HStack {
                                                Text(address.postcode)
                                                Text(address.state)
                                            }
                                        }
                                        .foregroundStyle(.blacky)
                                        Spacer()
                                        VStack {
                                            Button(action: {
                                                
                                            }, label: {
                                                Image(systemName: "trash")
                                                    .foregroundStyle(.red)
                                            })
                                            Spacer()
                                        }
                                    }
                                    .padding(15)
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.black, lineWidth: 1)
                                }
                                .frame(height: 120)
                                .padding(5)
                            }
                            .padding(.horizontal)
                        } else {
                            NavigationLink(destination: {
                                AddAddress()
                                    .environmentObject(appModel)
                            }, label: {
                                ButtonLabel(text: "Add Address")
                                    .padding(.horizontal, 40)
                            })
                        }
                    }
                    .padding([.horizontal, .top])
                    
                    Spacer()
                }
                .padding(.top)
            }
            .navigationBarBackButtonHidden()
            .task {
                deliveryAddress = appModel.dataManager.currentUser.address
            }
            .toolbar {
                Toolbar(title: "Select Address")
            }
        }
    }
}

#Preview {
    SelectAddress(selectedAddress: .constant(.init()))
        .environmentObject(AppModel())
}
