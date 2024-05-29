//
//   DisplayAR.swift
//   Decobliss
//
//   Created by @kinderBono on 28/05/2024.
//   

import SwiftUI
import ARKit
import RealityKit

struct DisplayAR: View {
    var name: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.whitey.ignoresSafeArea()
                
                VStack {
                    ARContainer().edgesIgnoringSafeArea([.horizontal, .bottom])
                }
                .padding(.top)
            }
            .navigationBarBackButtonHidden()
            .toolbar {
                Toolbar(title: name)
            }
        }
        .environment(\.colorScheme, .light)
    }
}

struct ARContainer: UIViewRepresentable {
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
}

#Preview {
    DisplayAR()
}
