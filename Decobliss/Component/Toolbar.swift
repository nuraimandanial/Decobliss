//
//   Toolbar.swift
//   Decobliss
//
//   Created by @kinderBono on 27/05/2024.
//   

import SwiftUI

struct Toolbar: ToolbarContent {
    @Environment(\.dismiss) var dismiss
    
    var title: String = ""
    var font: Font = .title2
    
    var body: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarLeading) {
            Button(action: {
                dismiss()
            }, label: {
                Image(systemName: "chevron.left")
                    .imageScale(.large)
                    .foregroundStyle(.yellows)
            })
            Text(title)
                .font(font)
                .bold()
        }
    }
}
