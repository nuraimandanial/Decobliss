//
//   UserTabView.swift
//   Decobliss
//
//   Created by @kinderBono on 27/05/2024.
//   

import SwiftUI

struct UserTabView: View {
    @EnvironmentObject var appModel: AppModel
    
    var body: some View {
        TabView(selection: $appModel.selectedTab) {
            
        }
    }
}

#Preview {
    UserTabView()
        .environmentObject(AppModel())
}
