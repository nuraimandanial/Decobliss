//
//   SplashScreen.swift
//   Decobliss
//
//   Created by @kinderBono on 28/05/2024.
//   

import SwiftUI

struct SplashScreen: View {
    var body: some View {
        ZStack {
            Color.yellows.ignoresSafeArea()
            Image("logo")
                .resizable().scaledToFit()
                .frame(width: 300)
        }
    }
}

#Preview {
    SplashScreen()
}
