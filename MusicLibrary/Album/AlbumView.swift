//
//  AlbumView.swift
//  MusicLibrary
//
//  Created by Alibek Shakirov on 19.03.2024.
//

import SwiftUI

struct AlbumView: View {
    
    @StateObject var viewModel: AlbumViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.albums, id: \.id) { album in
                HStack {
                    imageView(urlString: album.artworkUrl100, size: 100)
                    VStack(alignment: .leading) {
                        Text(album.collectionName)
                            .lineLimit(2)
                        Text(album.artistName)
                            .font(.caption)
                            .foregroundColor(.gray)
                            .lineLimit(2)
                    }
                }
            }
            ProgressView()
                .progressViewStyle(.circular)
            onAppear {
                viewModel.loadMore()
            }
        }
        .searchable(text: $viewModel.searchItem)
    }
    
    func imageView(urlString: String, size: CGFloat) -> some View {
        AsyncImage(url: URL(string: urlString))
            .frame(height: size)
    }
}
