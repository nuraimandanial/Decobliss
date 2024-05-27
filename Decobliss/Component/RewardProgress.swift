//
//  RewardProgress.swift
//  Decor
//
//  Created by kinderBono on 16/01/2024.
//

import SwiftUI

struct RewardProgress: View {
    let totalPoints: Float = 1000
    let checkpoints: [Float] = [200, 500, 800, 1000]
    var points: Int = 200
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: 15)
                    .foregroundStyle(.gray)
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: progress(geometry: geometry), height: 15)
                    .foregroundStyle(.yellows)
                    .animation(.easeIn, value: points)
                
                ForEach(checkpoints, id: \.self) { checkpoint in
                    checkpointView(checkpoint: checkpoint, width: geometry)
                }
            }
            .frame(height: 50)
        }
    }
    
    func progress(geometry: GeometryProxy) -> CGFloat {
        return CGFloat(Float(points)/totalPoints) * geometry.size.width
    }
    
    @ViewBuilder
    func checkpointView(checkpoint: Float, width: GeometryProxy) -> some View {
        let position = CGFloat(checkpoint/totalPoints) * width.size.width
        ZStack {
            Circle()
                .frame(width: 20)
                .foregroundStyle(points >= Int(checkpoint) ? .yellows : .gray)
            Circle()
                .stroke(points >= Int(checkpoint) ? .black : .gray, lineWidth: 1)
                .frame(width: 20)
        }
        .position(x: position, y: 25)
    }
}

#Preview {
    RewardProgress()
}
