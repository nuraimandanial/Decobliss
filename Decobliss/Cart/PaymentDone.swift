//
//   PaymentDone.swift
//   Decobliss
//
//   Created by @kinderBono on 27/05/2024.
//   

import SwiftUI

struct PaymentDone: View {
    @EnvironmentObject var appModel: AppModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.whitey.ignoresSafeArea()
                
                VStack(spacing: 30) {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150)
                        .foregroundStyle(.yellows)
                    Text("Thank You")
                        .font(.title)
                        .bold()
                    Text("Your order is completed")
                        .font(.title3)
                    Button(action: {
                        dismiss()
                        appModel.selectedTab = 0
                    }, label: {
                        ButtonLabel(text: "Continue Shopping")
                            .padding(.horizontal, 40)
                    })
                }
                .padding()
                .foregroundStyle(.blacky)
            }
            .navigationBarBackButtonHidden()
        }
    }
}

#Preview {
    PaymentDone()
        .environmentObject(AppModel())
}
