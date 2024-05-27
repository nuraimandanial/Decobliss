//
//   ButtonLabel.swift
//   Decobliss
//
//   Created by @kinderBono on 27/05/2024.
//   

import SwiftUI

struct ButtonLabel: View {
    var text: String = ""
    var image: String = ""
    var color: Color = .yellows
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(color)
            RoundedRectangle(cornerRadius: 10)
                .stroke(.blacky, lineWidth: 1)
            HStack {
                if image != "" {
                    Image(systemName: image)
                }
                Text(text)
                    .bold()
            }
            .padding()
            .foregroundStyle(color != .red ? .blacky : .whitey)
        }
        .frame(height: 60)
        .environment(\.colorScheme, .light)
    }
}

#Preview {
    ButtonLabel()
}
