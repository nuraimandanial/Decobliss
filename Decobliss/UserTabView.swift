//
//   UserTabView.swift
//   Decobliss
//
//   Created by @kinderBono on 27/05/2024.
//   

import SwiftUI

struct UserTabView: View {
    @EnvironmentObject var appModel: AppModel
    
    var tabs: [TabItem] = [
        TabItem(view: AnyView(HomeView()), name: "Home", icon: "house"),
        TabItem(view: AnyView(RewardView()), name: "Reward", icon: "crown"),
        TabItem(view: AnyView(CartView()), name: "Cart", icon: "cart"),
        TabItem(view: AnyView(AccountView()), name: "Account", icon: "person.fill"),
    ]
    
    @State var alert: Bool = false
    
    var body: some View {
        TabView(selection: $appModel.selectedTab) {
            ForEach(tabs.indices, id: \.self) { index in
                tabs[index].view.tag(index)
                    .environmentObject(appModel)
                    .tabItem { Label(tabs[index].name, systemImage: tabs[index].icon) }
                    .overlay {
                        if !appModel.isLoggedIn {
                            if tabs[index].name == "Reward" || tabs[index].name == "Cart" {
                                Color.white.ignoresSafeArea()
                            }
                        }
                    }
                    .onAppear {
                        if !appModel.isLoggedIn {
                            if tabs[index].name == "Reward" || tabs[index].name == "Cart" {
                                alert = true
                            }
                        }
                    }
            }
        }
        .environment(\.colorScheme, .light)
        .alert(isPresented: $alert) {
            Alert(title: Text("Not Available!"), message: Text("If you want to access this tab, you are required to log in first."), primaryButton: .cancel(), secondaryButton: .default(Text("Log In"), action: {
                alert = false
                appModel.selectedTab = 3
            }))
        }
    }
}

#Preview {
    UserTabView()
        .environmentObject(AppModel())
}

struct TabItem {
    var view: AnyView
    var name: String
    var icon: String
}
