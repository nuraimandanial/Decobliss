//
//  iOSCheckbox.swift
//  Decor
//
//  Created by kinderBono on 14/01/2024.
//

import SwiftUI

struct iOSCheckbox: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Button(action: {
                configuration.isOn.toggle()
            }, label: {
                ZStack {
                    Image(systemName: "square.fill")
                        .foregroundStyle(.white)
                    Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                }
                .foregroundStyle(.yellows)
            })
            configuration.label
        }
        .environment(\.colorScheme, .light)
    }
}
