//
//  SearchBar.swift
//  Decor
//
//  Created by kinderBono on 11/01/2024.
//

import SwiftUI

struct SearchBar: View {
    @EnvironmentObject var appModel: AppModel
    
    @Binding var searchText: String
    
    var body: some View {
        NavigationStack {
            HStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(.white)
                    HStack {
                        Image(systemName: "magnifyingglass")
                        TextField("Search", text: $searchText)
                    }
                    .padding(10)
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.blacky, lineWidth: 1)
                }
                .frame(height: 50)
                NavigationLink(destination: {
                    InboxView()
                        .environmentObject(appModel)
                }, label: {
                    Image(systemName: "bubble.left.and.text.bubble.right")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40)
                        .foregroundStyle(.yellows)
                })
            }
            .environment(\.colorScheme, .light)
        }
    }
}

#Preview {
    SearchBar(searchText: .constant(""))
        .environmentObject(AppModel())
}
