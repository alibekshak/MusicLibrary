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
        Group {
            if viewModel.searchItem.isEmpty {
                PlaceholderView(searchTerm: $viewModel.searchItem)
            } else {
                albums
            }
        }
        .searchable(text: $viewModel.searchItem)
    }
    
    var albums: some View {
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
                .onTapGesture {
                    
                }
            }
            
            switch viewModel.state{
            case .good:
                Color.clear
                    .onAppear{
                        viewModel.loadMore()
                    }
            case .isLoading:
                ProgressView("Loading Albums...")
                    .progressViewStyle(.circular)
                    .frame(maxWidth: .infinity)
                    
            case .loadedAll:
                EmptyView()
            case .noResults:
                Text("Could not find anything")
                    .foregroundColor(.gray)
            case .error(let error):
                Text("\(error)")
            }
        }
        .listStyle(.grouped)
    }
    
    func imageView(urlString: String, size: CGFloat) -> some View {
        AsyncImage(url: URL(string: urlString)) { phase in
            switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: size)
                case .failure(_):
                    Color.gray
                        .frame(width: size)
                case .success(let image):
                    image
                        .border(Color(white: 0.8))
                default:
                    EmptyView()
            }
        }
        .frame(height: size)
    }
}
