//
//   RegisterView.swift
//   Decobliss
//
//   Created by @kinderBono on 28/05/2024.
//   

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var appModel: AppModel
    @Environment(\.dismiss) var dismiss
    
    @State var username: String = ""
    @State var email: String = ""
    @State var phone: String = ""
    @State var password: String = ""
    @State var confirmPassword: String = ""
    
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
                        HStack(spacing: 10) {
                            Text("Username")
                                .frame(width: 80, height: 60, alignment: .leading)
                            TextBox(hint: "Enter Username", text: $username)
                        }
                        HStack(spacing: 10) {
                            Text("Email")
                                .frame(width: 80, height: 60, alignment: .leading)
                            TextBox(hint: "Enter Email", text: $email)
                        }
                        HStack(spacing: 10) {
                            Text("Phone Number")
                                .frame(width: 80, height: 60, alignment: .leading)
                            TextBox(hint: "Enter Phone Number", text: $phone)
                        }
                        HStack(spacing: 10) {
                            Text("Password")
                                .frame(width: 80, height: 60, alignment: .leading)
                            TextBox(hint: "Enter Password", text: $password, fieldType: .password)
                        }
                        HStack(spacing: 10) {
                            Text("Confirm Password")
                                .frame(width: 80, height: 60, alignment: .leading)
                            TextBox(hint: "Confirm Password", text: $confirmPassword, fieldType: .password)
                        }
                    }
                    .padding()
                    
                    Button(action: {
                        register()
                    }, label: {
                        ButtonLabel(text: "Sign Up")
                            .padding(.horizontal, 40)
                    })
                    .alert(isPresented: $alert) {
                        Alert(title: Text(success ? "Success!" : "Error!"), message: Text(alertMessage), dismissButton: .default(Text("OK"), action: {
                            if success {
                                dismiss()
                            }
                        }))
                    }
                    
                    Spacer()
                }
                .padding(.top)
            }
            .navigationBarBackButtonHidden()
            .toolbar {
                Toolbar(title: "Register")
            }
        }
    }
    
    func register() {
        guard password == confirmPassword else {
            alertMessage = "Password not match!"
            alert = true
            return
        }
        
        appModel.authManager.signUp(email: email, password: password, username: username, phone: phone) { error in
            if let error = error {
                alertMessage = error.localizedDescription
            } else {
                alertMessage = "Registration Successful: \(email)"
                success = true
            }
            alert = true
        }
    }
}

#Preview {
    RegisterView()
        .environmentObject(AppModel())
}
