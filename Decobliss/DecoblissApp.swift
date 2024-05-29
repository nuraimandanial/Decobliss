//
//  DecoblissApp.swift
//  Decobliss
//
//  Created by @kinderBono on 26/05/2024.
//

import SwiftUI
import Firebase

@main
struct DecoblissApp: App {
    @StateObject var appModel = AppModel()
    @AppStorage("isFirstTime") var isFirstTime: Bool = true
    
    @State var splash: Bool = true
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor.init(Color.white)
        UITabBar.appearance().unselectedItemTintColor = UIColor.init(Color.yellows.opacity(0.65))
        UITabBar.appearance().barTintColor = UIColor.init(Color.whitey)
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if splash {
                    if isFirstTime {
                        OnboardingScreen(dismiss: $splash)
                            .onDisappear {
                                isFirstTime = false
                            }
                    } else {
                        SplashScreen()
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                                    withAnimation {
                                        splash = false
                                    }
                                })
                            }
                    }
                } else {
                    if appModel.dataManager.currentUser.isSeller {
                        AdminTabView()
                            .environmentObject(appModel)
                    } else {
                        UserTabView()
                            .environmentObject(appModel)
                    }
                }
            }
        }
        .environment(\.colorScheme, .light)
    }
}
