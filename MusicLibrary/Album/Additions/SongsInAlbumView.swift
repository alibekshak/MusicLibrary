//
//  SongsInAlbumView.swift
//  MusicLibrary
//
//  Created by Alibek Shakirov on 21.03.2024.
//

import SwiftUI

struct SongsInAlbumView: View {
    
    @StateObject var songsViewModel: SongForAlbumViewModel
    
    var body: some View {
        Group {
            if songsViewModel.state == .isLoading || songsViewModel.songs.isEmpty {
                Spacer()
                ProgressView()
                    .progressViewStyle(.circular)
                Spacer()
            } else {
                VStack {
                    navigationBar
                    songs
                }
            }
        }
        .onAppear {
            songsViewModel.fetch()
        }
    }
    
    var navigationBar: some View {
        HStack(alignment: .center, spacing: .none) {
            Button {
                songsViewModel.onEvent?(.dismiss)
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "chevron.left")
                    Text("Back")
                }
                .font(.title3)
                .foregroundColor(Color(.label))
            }
            Spacer()
            Text("Songs")
                .font(
                    .system(
                        size: 24,
                        weight: .bold,
                        design: .serif
                    )
                )
            Spacer()
            Spacer()
        }
        .padding(.top, 12)
        .padding(.horizontal, 24)
        .padding(.bottom, 8)
    }
    
    var songs: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(songsViewModel.songs) { song in
                    HStack(spacing: 10){
                        Text("\(song.trackNumber)")
                            .font(.footnote)
                            .frame(width: 25, alignment: .trailing)
                            .foregroundColor(.black)
                        
                        ImageLoadingView(urlString: song.artworkUrl60, size: 60)
                        
                        VStack(alignment: .leading){
                            Text("\(song.country)")
                                .font(.footnote)
                                .foregroundColor(.black)
                            Text(song.trackName)
                                .font(.headline)
                                .truncationMode(.tail)
                                .foregroundColor(.black)
                            Text(song.artistName)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .lineLimit(1)
                    }
                    .id(song.trackNumber)
                    Divider()
                }
            }
        }
    }
}
