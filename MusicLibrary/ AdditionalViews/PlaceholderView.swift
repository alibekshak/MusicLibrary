//
//  PlaceholderView.swift
//  MusicLibrary
//
//  Created by Alibek Shakirov on 21.03.2024.
//

import SwiftUI

struct PlaceholderView: View {
    
    @Binding var searchTerm: String
    
    let suggestion = ["Eminem", "KOLEO", "Drake"]
    
    var body: some View {
        VStack(spacing: 15){
            Text("Choose your artist")
                .font(.title)
            ForEach(suggestion, id: \.self){ text in
                Button{
                    searchTerm = text
                } label: {
                    Text(text)
                }
            }
        }
    }
}
