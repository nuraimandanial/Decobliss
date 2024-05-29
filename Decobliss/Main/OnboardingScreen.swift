//
//   OnboardingScreen.swift
//   Decobliss
//
//   Created by @kinderBono on 28/05/2024.
//   

import SwiftUI

struct OnboardingScreen: View {
    @Binding var dismiss: Bool
    
    var body: some View {
        ZStack {
            Color.yellows.ignoresSafeArea()
            
            VStack {
                Image("logo")
                    .resizable().scaledToFit()
                Button(action: {
                    dismiss = false
                }, label: {
                    ButtonLabel(text: "Get Started", color: .white)
                        .padding(.horizontal, 40)
                })
            }
        }
    }
}

#Preview {
    OnboardingScreen(dismiss: .constant(false))
}
