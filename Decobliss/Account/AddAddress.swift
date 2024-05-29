//
//   AddAddress.swift
//   Decobliss
//
//   Created by @kinderBono on 27/05/2024.
//   

import SwiftUI

struct AddAddress: View {
    @EnvironmentObject var appModel: AppModel
    @Environment(\.dismiss) var dismiss
    
    @State var newAddress: Address = .init()
    
    @State var alert: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.whitey.ignoresSafeArea()
                
                VStack {
                    Divider()
                    
                    VStack(spacing: 20) {
                        TextBox(hint: "Name", text: $newAddress.name)
                        TextBox(hint: "Phone", text: $newAddress.phone)
                        TextBox(hint: "Block/Unit", text: $newAddress.block)
                        TextBox(hint: "Address", text: $newAddress.address)
                        TextBox(hint: "Postcode", text: $newAddress.postcode)
                        TextBox(hint: "State", text: $newAddress.state)
                        
                        Spacer()
                        
                        Button(action: {
                            appModel.dataManager.addAddress(with: newAddress)
                            alert = true
                        }, label: {
                            ButtonLabel(text: "Add")
                                .padding(.horizontal, 40)
                        })
                        .alert(isPresented: $alert) {
                            Alert(title: Text("Success"), message: Text("New delivery address added!"), dismissButton: .default(Text("OK"), action: {
                                dismiss()
                            }))
                        }
                    }
                    .padding()
                }
                .padding(.top)
            }
            .navigationBarBackButtonHidden()
            .toolbar {
                Toolbar(title: "Add New Address")
            }
        }
    }
}

#Preview {
    AddAddress()
        .environmentObject(AppModel())
}
