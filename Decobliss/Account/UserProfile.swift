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
    @State var alert: Bool = false
    @State var alertMessage: String = ""
    
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
                            updateProfile()
                        }, label: {
                            ButtonLabel(text: "Update Profile")
                                .padding(.horizontal, 40)
                        })
                        .alert(isPresented: $success) {
                            Alert(title: Text(success ? "Success!" : "Error"), message: Text(alertMessage), dismissButton: .default(Text("OK"), action: {
                                if success {
                                    dismiss()
                                }
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
    
    func updateProfile() {
        appModel.dataManager.updateProfile(with: profile) { error in
            if let error = error {
                alertMessage = "Error Updating Profile: \(error.localizedDescription)"
            } else {
                success = true
                alertMessage = "Profile information updated."
            }
            alert = true
        }
    }
}

#Preview {
    UserProfile()
        .environmentObject(AppModel())
}
