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
    @AppStorage("isFirstTime") var isFirstTime: Bool = false
    
    @State var splash: Bool = false
    
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
                        
                    } else {
                        
                    }
                } else {
                    
                }
            }
        }
        .environment(\.colorScheme, .light)
    }
}
