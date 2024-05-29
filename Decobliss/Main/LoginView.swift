//
//   LoginView.swift
//   Decobliss
//
//   Created by @kinderBono on 28/05/2024.
//   

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var appModel: AppModel
    
    @State var email: String = ""
    @State var password: String = ""
    
    @State var success: Bool = false
    @State var alert: Bool = false
    @State var alertMessage: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.whitey.ignoresSafeArea()
                
                VStack(spacing: 40) {
                    Spacer()
                    VStack {
                        Image("logo")
                            .resizable().scaledToFit()
                            .frame(width: 150)
                            .clipShape(Circle())
                        Text("Login")
                            .font(.title)
                            .bold()
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(spacing: 10) {
                            Text("Email")
                                .font(.title3)
                                .frame(width: 90, alignment: .leading)
                            TextBox(hint: "Enter Email", text: $email)
                        }
                        HStack(spacing: 10) {
                            Text("Password")
                                .font(.title3)
                                .frame(width: 90, alignment: .leading)
                            TextBox(hint: "Enter Password", text: $password, fieldType: .password)
                        }
                        HStack {
                            Spacer()
                            NavigationLink(destination: {
                                ForgotPassword()
                                    .environmentObject(appModel)
                            }, label: {
                                Text("Forgot Password?")
                                    .underline()
                                    .foregroundStyle(.yellows)
                            })
                        }
                    }
                    .padding(.horizontal)
                    
                    Button(action: {
                        login()
                    }, label: {
                        ButtonLabel(text: "Login")
                            .padding(.horizontal, 40)
                    })
                    .alert(isPresented: $alert) {
                        Alert(title: Text(success ? "Success" : "Error"), message: Text(alertMessage), dismissButton: .default(Text("OK"), action: {
                            if success {
                                appModel.isLoggedIn = true
                            }
                        }))
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 10) {
                        Text("Don't have an Account?")
                        NavigationLink(destination: {
                            RegisterView()
                                .environmentObject(appModel)
                        }, label: {
                            Text("Sign Up")
                                .foregroundStyle(.yellows)
                        })
                    }
                    .padding(.bottom)
                }
                .padding()
                .foregroundStyle(.blacky)
            }
            .navigationBarBackButtonHidden()
        }
    }
    
    func login() {
        appModel.authManager.signIn(email: email, password: password) { result in
            switch result {
            case .success(let user):
                appModel.dataManager.currentUser = user
                alertMessage = "Login Success: \(user.profile.username)"
                success = true
            case .failure(let error):
                alertMessage = "Login Failed: \(error.localizedDescription)"
            }
            alert = true
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AppModel())
}
