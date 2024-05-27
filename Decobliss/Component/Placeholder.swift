//
//  Placeholder.swift
//  Decor
//
//  Created by kinderBono on 14/01/2024.
//

import SwiftUI

struct Placeholder: View {
    var width: CGFloat = 180
    var height: CGFloat = 120

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.gray.opacity(0.25))
                .frame(width: width, height: height)
            VStack {
                Text("Placeholder Image")
            }
            .padding()
        }
        .frame(width: width, height: height)
        .environment(\.colorScheme, .light)
    }
    
    enum Shape {
        case circle, rectangle, roundedRectangle
    }
}

#Preview {
    Placeholder()
}
