//
//   ForgotPassword.swift
//   Decobliss
//
//   Created by @kinderBono on 28/05/2024.
//   

import SwiftUI

struct ForgotPassword: View {
    @EnvironmentObject var appModel: AppModel
    @Environment(\.dismiss) var dismiss
    
    @State var email: String = ""
    
    @State var alert: Bool = false
    @State var alertMessage: String = ""
    @State var success: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.whitey.ignoresSafeArea()
                
                VStack {
                    Divider()
                    
                    VStack(spacing: 40) {
                        VStack(spacing: 20) {
                            Text("Please Enter Your Email Address")
                                .bold()
                            Text("You will receive a link to create a new password via email.")
                        }
                        .foregroundStyle(.blacky)
                        TextBox(hint: "Enter Email", text: $email)
                        Button(action: {
                            resetPassword()
                        }, label: {
                            ButtonLabel(text: "Submit")
                                .padding(.horizontal, 40)
                        })
                        .alert(isPresented: $alert) {
                            Alert(title: Text(""), message: Text(alertMessage), dismissButton: .default(Text("OK"), action: {
                                if success {
                                    dismiss()
                                }
                            }))
                        }
                        
                        Spacer()
                    }
                    .padding()
                }
                .padding(.top)
            }
            .navigationBarBackButtonHidden()
            .toolbar {
                Toolbar(title: "Forgot Password")
            }
        }
    }
    
    func resetPassword() {
        appModel.authManager.resetPassword(with: email) { error in
            if let error = error {
                alertMessage = error.localizedDescription
            } else {
                alertMessage = "Your request to reset password has been sent to your email"
                success = true
            }
            alert = true
        }
    }
}

#Preview {
    ForgotPassword()
        .environmentObject(AppModel())
}
