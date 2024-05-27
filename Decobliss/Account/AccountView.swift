//
//   AccountView.swift
//   Decobliss
//
//   Created by @kinderBono on 27/05/2024.
//   

import SwiftUI

struct AccountView: View {
    @EnvironmentObject var appModel: AppModel
    
    var body: some View {
        NavigationStack {
            if appModel.isLoggedIn {
                ProfileView()
                    .environmentObject(appModel)
            } else {
                
            }
        }
    }
}

#Preview {
    AccountView()
        .environmentObject(AppModel())
}
