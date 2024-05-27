//
//   ChangePassword.swift
//   Decobliss
//
//   Created by @kinderBono on 27/05/2024.
//   

import SwiftUI

struct ChangePassword: View {
    @EnvironmentObject var appModel: AppModel
    @Environment(\.dismiss) var dismiss
    
    @State var currentPassword: String = ""
    @State var newPassword: String = ""
    @State var confirmPassword: String = ""
    
    @State var alert: Bool = false
    @State var alertMessage: String = ""
    @State var success: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.whitey.ignoresSafeArea()
                
                VStack {
                    Divider()
                    VStack(spacing: 20) {
                        TextBox(hint: "Current Password", text: $currentPassword, fieldType: .password)
                        TextBox(hint: "New Password", text: $newPassword, fieldType: .password)
                        TextBox(hint: "Confirm Password", text: $confirmPassword, fieldType: .password)
                        
                        Spacer()
                        
                        Button(action: {
                            updatePassword()
                        }, label: {
                            ButtonLabel(text: "Update Password")
                        })
                        .alert(isPresented: $alert) {
                            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                        }
                        .alert(isPresented: $success) {
                            Alert(title: Text("Success"), message: Text("Your password has been updated!"), dismissButton: .default(Text("OK"), action: {
                                dismiss()
                            }))
                        }
                    }
                    .padding([.horizontal, .top])
                }
                .padding(.top)
            }
            .navigationBarBackButtonHidden()
            .toolbar {
                Toolbar(title: "Change Password")
            }
        }
    }
    
    func updatePassword() {
        guard newPassword == confirmPassword else {
            alertMessage = "Password not match!"
            alert = true
            return
        }
        
        appModel.dataManager.updatePassword(currentPassword: currentPassword, newPassword: newPassword) { error in
            if let error = error {
                alertMessage = "Error Updating Password: \(error.localizedDescription)"
            } else {
                success = true
            }
        }
    }
}

#Preview {
    ChangePassword()
        .environmentObject(AppModel())
}
