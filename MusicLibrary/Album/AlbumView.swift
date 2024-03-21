//
//  AlbumView.swift
//  MusicLibrary
//
//  Created by Alibek Shakirov on 19.03.2024.
//

import SwiftUI

struct AlbumView: View {
    
    @StateObject var viewModel: AlbumViewModel
    
    @State private var selectedEntityType = EntityType.album
    
    var body: some View {
        VStack {
            picker
            Group {
                if viewModel.searchItem.isEmpty {
                    PlaceholderView(searchTerm: $viewModel.searchItem)
                } else {
                    albums
                }
            }
        }
        .searchable(text: $viewModel.searchItem)
    }
    
    var picker: some View {
        Picker("Select", selection: $selectedEntityType) {
            ForEach(EntityType.allCases) { type in
                Text(type.name())
                    .tag(type)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
    }
    
    var albums: some View {
        List {
            ForEach(viewModel.albums, id: \.id) { album in
                HStack {
                    ImageLoadingView(urlString: album.artworkUrl100, size: 100)
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
                    viewModel.showAlbumSongs(songID: album.id)
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
        .listStyle(.plain)
    }
}
