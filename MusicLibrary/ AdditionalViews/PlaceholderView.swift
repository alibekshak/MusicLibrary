//
//  PlaceholderView.swift
//  MusicLibrary
//
//  Created by Alibek Shakirov on 21.03.2024.
//

import SwiftUI

struct PlaceholderView: View {
    
    @Binding var searchTerm: String
    
    let suggestion = [
        Artists(image: "drake", name: "Drake", term: "Artist"),
        Artists(image: "koleo", name: "KOLEO", term: "Artist"),
        Artists(image: "eminem", name: "Eminem", term: "Artist"),
        Artists(image: "ac-dc", name: "AC/DC", term: "Artist"),
        Artists(image: "ledZeppelin", name: "Led Zeppelin", term: "Artist"),
        Artists(image: "adele", name: "Adele", term: "Artist"),
        Artists(image: "beatles", name: "Beatles", term: "Artist"),
        Artists(image: "queen", name: "Queen", term: "Artist"),
        Artists(image: "ray", name: "Ray Charles", term: "Artist"),
        Artists(image: "louis", name: "Louis Armstrong", term: "Artist")
    ]
    
    var body: some View {
        VStack(spacing: 15){
            Text("Choose your artist")
                .font(.title)
            List {
                ForEach(suggestion, id: \.self){ artist in
                    Button{
                        searchTerm = artist.name
                    } label: {
                        HStack {
                            Image(artist.image)
                                .resizable()
                                .frame(width: 75, height: 75)
                                .cornerRadius(12)
                            VStack(alignment: .leading) {
                                Text(artist.name)
                                    .font(.headline)
                                Text(artist.term)
                                    .font(.subheadline)
                            }
                        }
                    }
                }
            }
            .listStyle(.plain)
        }
    }
}
