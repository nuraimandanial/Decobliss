//
//   UserProfile.swift
//   Decobliss
//
//   Created by @kinderBono on 27/05/2024.
//   

import SwiftUI

struct UserProfile: View {
    @EnvironmentObject var appModel: AppModel
    @Environment(\.dismiss) var dismiss
    
    @State var profile: Profile = .init()
    @State var success: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.whitey.ignoresSafeArea()
                
                VStack {
                    Divider()
                    VStack(spacing: 20) {
                        TextBox(hint: "Email", text: $profile.email)
                            .disabled(true)
                        TextBox(hint: "First Name", text: $profile.details.firstName)
                        TextBox(hint: "Last Name", text: $profile.details.lastName)
                        TextBox(hint: "Username", text: $profile.username)
                        TextBox(hint: "Phone Number", text: $profile.details.phone)
                            .keyboardType(.numbersAndPunctuation)
                        
                        Spacer()
                        
                        Button(action: {
                            appModel.dataManager.updateProfile(with: profile) { error in
                                if let error = error {
                                    success = false
                                } else {
                                    success = true
                                }
                            }
                        }, label: {
                            ButtonLabel(text: "Update Profile")
                                .padding(.horizontal, 40)
                        })
                        .alert(isPresented: $success) {
                            Alert(title: Text("Success!"), message: Text("Profile Updated"), dismissButton: .default(Text("OK"), action: {
                                dismiss()
                            }))
                        }
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
                Toolbar(title: "My Profile")
            }
        }
    }
}

#Preview {
    UserProfile()
        .environmentObject(AppModel())
}
