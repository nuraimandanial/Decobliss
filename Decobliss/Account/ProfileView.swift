//
//   ProfileView.swift
//   Decobliss
//
//   Created by @kinderBono on 27/05/2024.
//   

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appModel: AppModel
    
    @State var profile: Profile = .init()
    @State var alert: Bool = false
    
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
                                .stroke(lineWidth: 1)
                            VStack(spacing: 10) {
                                HStack {
                                    Image(systemName: "shippingbox")
                                    Text("My Orders")
                                        .bold()
                                    Spacer()
                                }
                                HStack(alignment: .top, spacing: 10) {
                                    NavigationLink(destination: {
                                        PendingPayment()
                                            .environmentObject(appModel)
                                    }, label: {
                                        orderButton("creditcard", text: "Pending Payment")
                                    })
                                    NavigationLink(destination: {
                                        PendingPayment()
                                            .environmentObject(appModel)
                                    }, label: {
                                        orderButton("truck.box.badge.clock", text: "To Ship")
                                    })
                                    NavigationLink(destination: {
                                        PendingPayment()
                                            .environmentObject(appModel)
                                    }, label: {
                                        orderButton("star.circle", text: "Reviews")
                                    })
                                    NavigationLink(destination: {
                                        PendingPayment()
                                            .environmentObject(appModel)
                                    }, label: {
                                        orderButton("shippingbox.and.arrow.backward", text: "Return Refund")
                                    })
                                }
                                .multilineTextAlignment(.center)
                            }
                            .padding()
                        }
                        .frame(height: 140)
                        
                        VStack {
                            NavigationLink(destination: {
                                UserProfile()
                                    .environmentObject(appModel)
                            }, label: {
                                ButtonLabel(text: "User Profile", image: "person", color: .white)
                            })
                            NavigationLink(destination: {
                                ChangePassword()
                                    .environmentObject(appModel)
                            }, label: {
                                ButtonLabel(text: "Change Password", image: "lock.shield", color: .white)
                            })
                            NavigationLink(destination: {
                                DeliveryAddress()
                                    .environmentObject(appModel)
                            }, label: {
                                ButtonLabel(text: "Delivery Address", image: "mappin", color: .white)
                            })
                            Button(action: {
                                alert = true
                            }, label: {
                                ButtonLabel(text: "Log Out", image: "figure.walk.arrival", color: .red)
                            })
                            .alert(isPresented: $alert) {
                                Alert(title: Text("Confirm to Log Out?"), message: Text("Are you sure?"), primaryButton: .cancel(), secondaryButton: .destructive(Text("Log Out"), action: {
                                    logout()
                                }))
                            }
                        }
                        
                        Spacer()
                    }
                    .padding([.horizontal, .top])
                }
                .padding(.top)
            }
            .navigationBarBackButtonHidden()
            .task {
                profile = appModel.dataManager.currentUser.profile
            }
            .toolbar {
                ToolbarUser(image: profile.details.image, name: profile.username)
            }
        }
    }
    
    @ViewBuilder
    func orderButton(_ image: String, text: String) -> some View {
        VStack(spacing: 5) {
            Image(systemName: image)
                .resizable()
                .scaledToFit()
                .frame(height: 15)
            Text(text)
                .frame(width: 70)
        }
        .foregroundStyle(.blacky)
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
    ProfileView()
        .environmentObject(AppModel())
}
