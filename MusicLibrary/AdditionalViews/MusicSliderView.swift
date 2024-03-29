//
//  MusicSliderView.swift
//  MusicLibrary
//
//  Created by Alibek Shakirov on 29.03.2024.
//

import SwiftUI

struct MusicSliderView: View {
    @Binding var value: Double
    let range: ClosedRange<Double>
    
    var body: some View {
        GeometryReader { geometry in
            let relativeValue = max(0, min(1, (self.value - self.range.lowerBound) / (self.range.upperBound - self.range.lowerBound)))
            let xPos = CGFloat(relativeValue) * geometry.size.width
            
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(.gray)
                Rectangle()
                    .foregroundColor(value == 0 ? .clear : .white)
                    .frame(width: xPos)
            }
            .cornerRadius(12)
            .gesture(DragGesture(minimumDistance: 0)
                .onChanged { gesture in
                    let newValue = min(max(0, gesture.location.x / geometry.size.width), 1) * (self.range.upperBound - self.range.lowerBound) + self.range.lowerBound
                    self.value = min(max(newValue, self.range.lowerBound), self.range.upperBound)
                }
            )
        }
    }
}
