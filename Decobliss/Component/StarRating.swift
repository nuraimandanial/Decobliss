//
//  StarRating.swift
//  Decor
//
//  Created by kinderBono on 15/01/2024.
//

import SwiftUI

struct StarRating: View {
    var rating: Float = 4.5
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<5) { index in
                Image(systemName: self.star(for: index))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 15)
                    .foregroundStyle(.yellow)
            }
            Text("\(rating, specifier: "%.1f")")
                .font(.callout)
                .bold()
                .padding(.leading, 10)
                .foregroundStyle(.blacky)
        }
        .environment(\.colorScheme, .light)
    }
    
    private func star(for index: Int) -> String {
        let remainder = rating - Float(index)
        if remainder >= 1 {
            return "star.fill"
        } else if remainder > 0 {
            return "star.leadinghalf.fill"
        } else {
            return "star"
        }
    }
}

#Preview {
    StarRating()
}
