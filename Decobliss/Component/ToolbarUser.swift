//
//   ToolbarUser.swift
//   Decobliss
//
//   Created by @kinderBono on 27/05/2024.
//   

import SwiftUI

struct ToolbarUser: ToolbarContent {
    var image: String
    var name: String
    
    var body: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarLeading) {
            if image != "" {
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60)
                    .clipShape(Circle())
            }
            HStack(spacing: 10) {
                Text("Hi")
                    .font(.title3)
                Text("@\(name)")
                    .font(.headline)
                    .bold()
            }
            .foregroundStyle(.blacky)
        }
    }
}
