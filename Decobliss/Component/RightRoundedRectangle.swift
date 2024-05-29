//
//   RightRoundedRectangle.swift
//   Decobliss
//
//   Created by @kinderBono on 28/05/2024.
//   

import SwiftUI

struct RightRoundedRectangle: Shape {
    var radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let left = rect.minX
        let right = rect.maxX
        let top = rect.minY
        let bottom = rect.maxY
        
        path.move(to: CGPoint(x: left, y: top))
        path.addLine(to: CGPoint(x: right - radius, y: top))
        path.addArc(center: CGPoint(x: right - radius, y: top + radius), radius: radius, startAngle: .degrees(-90), endAngle: .degrees(0), clockwise: false)
        path.addLine(to: CGPoint(x: right, y: bottom - radius))
        path.addArc(center: CGPoint(x: right - radius, y: bottom - radius), radius: radius, startAngle: .degrees(0), endAngle: .degrees(90), clockwise: false)
        path.addLine(to: CGPoint(x: left, y: bottom))
        path.addLine(to: CGPoint(x: left, y: top))
        
        return path
    }
}

struct TopRoundedRectangle: Shape {
    var radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let left = rect.minX
        let right = rect.maxX
        let top = rect.minY
        let bottom = rect.maxY
        
        path.move(to: CGPoint(x: left, y: bottom))
        path.addLine(to: CGPoint(x: left, y: top + radius))
        path.addArc(center: CGPoint(x: left + radius, y: top + radius), radius: radius, startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false)
        path.addLine(to: CGPoint(x: right - radius, y: top))
        path.addArc(center: CGPoint(x: right - radius, y: top + radius), radius: radius, startAngle: .degrees(270), endAngle: .degrees(360), clockwise: false)
        path.addLine(to: CGPoint(x: right, y: bottom))
        path.addLine(to: CGPoint(x: left, y: bottom))
        
        return path
    }
}

struct LeftRoundedRectangle: Shape {
    var radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let left = rect.minX
        let right = rect.maxX
        let top = rect.minY
        let bottom = rect.maxY
        
        path.move(to: CGPoint(x: right, y: top))
        path.addLine(to: CGPoint(x: left + radius, y: top))
        path.addArc(center: CGPoint(x: left + radius, y: top + radius), radius: radius, startAngle: .degrees(270), endAngle: .degrees(180), clockwise: true)
        path.addLine(to: CGPoint(x: left, y: bottom - radius))
        path.addArc(center: CGPoint(x: left + radius, y: bottom - radius), radius: radius, startAngle: .degrees(180), endAngle: .degrees(90), clockwise: true)
        path.addLine(to: CGPoint(x: right, y: bottom))
        path.addLine(to: CGPoint(x: right, y: top))
        
        return path
    }
}
