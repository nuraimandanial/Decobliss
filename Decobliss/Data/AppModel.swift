//
//   AppModel.swift
//   Decobliss
//
//   Created by @kinderBono on 26/05/2024.
//   

import Foundation
import SwiftUI

class AppModel: ObservableObject {
    @Published var dataManager = DataManager()
    @Published var authManager = AuthManager()
    @Published var rewards = Reward.rewards
    
    @Published var selectedTab: Int = 0
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    
    private func chechAuthState() {
        authManager.checkAuth { [self] isAuthenticated in
            DispatchQueue.main.async {
                if isAuthenticated {
                    self.isLoggedIn = true
                } else {
                    self.isLoggedIn = false
                }
            }
        }
    }
}
