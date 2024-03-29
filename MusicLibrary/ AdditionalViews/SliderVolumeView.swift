//
//  SliderVolumeView.swift
//  MusicLibrary
//
//  Created by Alibek Shakirov on 29.03.2024.
//

import SwiftUI

struct SliderVolumeView: View {
    
    @Binding var percentage: Float
    
    var body: some View {
        GeometryReader { geometry in
            
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(.gray)
                Rectangle()
                    .foregroundColor(.white)
                    .frame(width: geometry.size.width * CGFloat(self.percentage))
            }
            .cornerRadius(12)
            .gesture(DragGesture(minimumDistance: 0)
                .onChanged({ value in
                    self.percentage = min(max(0, Float(value.location.x / geometry.size.width)), 1)
                }
                          )
            )
        }
    }
}
