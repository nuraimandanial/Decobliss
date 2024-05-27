//
//  TextBox.swift
//  Decor
//
//  Created by kinderBono on 11/01/2024.
//

import SwiftUI

struct TextBox: View {
    var hint: String = ""
    @Binding var text: String
    var fieldType: Field = .text
    
    var body: some View {
        if fieldType == .text {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.white)
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.blacky, lineWidth: 1)
                TextField(hint, text: $text)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .padding(10)
            }
            .frame(height: 60)
            .environment(\.colorScheme, .light)
        } else if fieldType == .password {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.white)
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.blacky, lineWidth: 1)
                SecureField(hint, text: $text)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .padding(10)
            }
            .frame(height: 60)
            .environment(\.colorScheme, .light)
        }
    }
    
    enum Field {
        case text, password
    }
}

#Preview {
    TextBox(text: .constant("Text"))
}
