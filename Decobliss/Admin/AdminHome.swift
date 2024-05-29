//
//   AdminHome.swift
//   Decobliss
//
//   Created by @kinderBono on 28/05/2024.
//

import SwiftUI

struct AdminHome: View {
    @EnvironmentObject var appModel: AppModel
    
    @State var productButton: Bool = false
    @State var advertismentButton: Bool = false
    
    @State var alert: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.whitey.ignoresSafeArea()
                
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 35)
                            .frame(height: 300)
                            .foregroundStyle(.yellows.opacity(0.5))
                            .padding(-5)
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120)
                            .clipShape(Circle())
                            .overlay {
                                Circle().stroke(lineWidth: 1)
                            }
                        HStack {
                            Spacer()
                            VStack {
                                NavigationLink(destination: {
                                    InboxView()
                                        .environmentObject(appModel)
                                }, label: {
                                    Image(systemName: "bubble.left.and.text.bubble.right")
                                        .imageScale(.large)
                                        .foregroundStyle(.blacky)
                                })
                                Spacer()
                            }
                        }
                        .padding(40)
                        .frame(height: 200)
                    }
                    
                    VStack(spacing: 10) {
                        Button(action: {
                            productButton.toggle()
                        }, label: {
                            ButtonLabel(text: "Product", image: "line.horizontal.3")
                        })
                        if productButton {
                            VStack(spacing: 5) {
                                NavigationLink(destination: {
                                    AddProduct()
                                        .environmentObject(appModel)
                                }, label: {
                                    ButtonLabel(text: "Add")
                                })
                                NavigationLink(destination: {
                                    ProductList()
                                        .environmentObject(appModel)
                                }, label: {
                                    ButtonLabel(text: "Edit")
                                })
                            }
                            .padding(.leading, 60)
                        }
                        Button(action: {
                            advertismentButton.toggle()
                        }, label: {
                            ButtonLabel(text: "Advertisement", image: "line.horizontal.3")
                        })
                        NavigationLink(destination: {
                            OrderHistory()
                                .environmentObject(appModel)
                        }, label: {
                            ButtonLabel(text: "Order History")
                        })
                    }
                    .padding([.horizontal, .top], 40)
                    
                    Spacer()
                    Spacer().frame(height: productButton ? 0 : 135)
                    
                    Button(action: {
                        alert = true
                    }, label: {
                        ButtonLabel(text: "Log Out", color: .red)
                            .padding(.horizontal, 40)
                    })
                    .alert(isPresented: $alert) {
                        Alert(title: Text("Confirm to Log Out?"), message: Text("Are you sure?"), primaryButton: .cancel(), secondaryButton: .destructive(Text("Log Out"), action: {
                            logout()
                        }))
                    }
                    
                    Spacer()
                }
                .ignoresSafeArea(edges: .top)
            }
        }
    }
    
    func logout() {
        appModel.authManager.signOut { error in
            if let error = error {
                print("Error Logging Out: \(error.localizedDescription)")
            } else {
                appModel.dataManager.saveUser()
                appModel.isLoggedIn = false
                appModel.selectedTab = 0
                appModel.dataManager.currentUser = .init()
            }
        }
        alert = false
    }
}

#Preview {
    AdminHome()
        .environmentObject(AppModel())
}
