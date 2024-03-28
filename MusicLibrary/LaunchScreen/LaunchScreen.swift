//
//  LaunchScreen.swift
//  MusicLibrary
//
//  Created by Alibek Shakirov on 28.03.2024.
//

import SwiftUI

struct LaunchScreen: View {
    
    @State private var isAnimating = false
    
    var body: some View {
        VStack {
            Image("music")
                .resizable()
                .scaledToFit()
                .scaleEffect(isAnimating ? 1.3 : 1.0)
                .animation(.easeInOut(duration: 1.0), value: isAnimating)
            ProgressView()
                .progressViewStyle(.circular)
        }
        .onAppear {
            self.isAnimating = true
        }
    }
}

#Preview {
    LaunchScreen()
}
