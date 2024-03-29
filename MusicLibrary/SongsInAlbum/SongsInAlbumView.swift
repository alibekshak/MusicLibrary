//
//  SongsInAlbumView.swift
//  MusicLibrary
//
//  Created by Alibek Shakirov on 21.03.2024.
//

import SwiftUI

struct SongsInAlbumView: View {
    
    @StateObject var viewModel: SongForAlbumViewModel
    
    var body: some View {
        Group {
            if viewModel.state == .isLoading || viewModel.songs.isEmpty {
                Spacer()
                ProgressView("Loading songs")
                    .progressViewStyle(.circular)
                Spacer()
            } else {
                VStack {
                    navigationBar
                    albumForSongs
                    songs
                }
            }
        }
    }
    
    var albumForSongs: some View {
        HStack(alignment: .center) {
            ImageLoadingView(urlString: viewModel.album.artworkUrl100, size: 100)
            VStack(alignment: .leading) {
                Text(viewModel.album.collectionName)
                    .font(.headline)
                    .foregroundColor(Color(.label))
                    .bold()
                
                Text(viewModel.album.artistName)
                    .padding(.bottom, 4)
                
                Text(viewModel.album.primaryGenreName)
                Text(viewModel.album.country)
            }
            .font(.subheadline)
            .foregroundColor(.gray)
            Spacer()
        }
        .padding()
        .background(
            Color(.systemBackground)
                .shadow(color: Color.black.opacity(0.3), radius: 3, x: 0, y: 5)
        )
    }
    
    var navigationBar: some View {
        HStack(alignment: .center, spacing: .none) {
            Button {
                viewModel.onEvent?(.dismiss)
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "chevron.left")
                    Text("Back")
                }
                .font(.system(
                    size: 18,
                    weight: .medium,
                    design: .rounded
                    )
                )
                .foregroundColor(Color(.label))
            }
            Spacer()
            Text("Songs")
                .font(
                    .system(
                        size: 24,
                        weight: .bold,
                        design: .rounded
                    )
                )
                .padding(.leading)
            Spacer()
            Spacer()
        }
        .padding(.top, 12)
        .padding(.horizontal, 18)
        .padding(.bottom, 8)
    }
    
    var songs: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(viewModel.songs) { song in
                    HStack(spacing: 12) {
                        Text("\(song.trackNumber)")
                            .font(.footnote)
                            .frame(width: 25, alignment: .trailing)
                            .foregroundColor(.black)
                        ImageLoadingView(urlString: song.artworkUrl60, size: 60)
                        VStack(alignment: .leading, spacing: 4){
                            Text(song.trackName)
                                .font(.headline)
                                .truncationMode(.tail)
                                .foregroundColor(.black)
                            Text(song.artistName)
                                .font(.caption)
                                .foregroundColor(.gray)
                                .lineLimit(1)
                        }
                        Spacer()
                        Text(formateDuration(time: song.trackTimeMillis))
                    }
                    .padding(.trailing)
                    .id(song.trackNumber)
                    .onTapGesture {
                        viewModel.onEvent?(.playAudio(song))
                    }
                    Divider()
                }
            }
            .padding(.top)
        }
    }
    
    func formateDuration(time: Int) -> String {
        let timeInSeconds = time / 1000
        
        let interval = TimeInterval(timeInSeconds)
        let formatter = DateComponentsFormatter()
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        
        return formatter.string(from: interval) ?? ""
    }
}
