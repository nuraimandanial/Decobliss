//
//   AdminTabView.swift
//   Decobliss
//
//   Created by @kinderBono on 27/05/2024.
//   

import SwiftUI

struct AdminTabView: View {
    @EnvironmentObject var appModel: AppModel
    
    var body: some View {
        AdminHome()
            .environmentObject(appModel)
            .environment(\.colorScheme, .light)
    }
}

#Preview {
    AdminTabView()
        .environmentObject(AppModel())
}
