//
//  SelectionButton.swift
//  Decor
//
//  Created by kinderBono on 19/01/2024.
//

import SwiftUI

struct SelectionButton: View {
    @Binding var selection: Bool
    
    var body: some View {
        Button(action: {
            selection.toggle()
        }, label: {
            ZStack {
                Circle()
                    .stroke(lineWidth: 2)
                    .frame(width: 20, height: 20)
                if selection {
                    Circle()
                        .frame(width: 12, height: 12)
                }
            }
            .foregroundStyle(.yellows)
        })
    }
}

#Preview {
    SelectionButton(selection: .constant(true))
}
