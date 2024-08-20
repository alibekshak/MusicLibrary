//
//  PlayAudioView.swift
//  MusicLibrary
//
//  Created by Alibek Shakirov on 25.03.2024.
//

import SwiftUI
import AVKit

struct PlayAudioView: View {
    
    @StateObject var viewModel: PlayAudioViewModel
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            let safeArea = $0.safeAreaInsets
            
            ZStack {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .overlay {
                        Rectangle()
                            .fill(.gray.opacity(0.8))
                            .blur(radius: 55)
                    }
                VStack(spacing: 15) {
                    navigationBar
                    imageView
                        .frame(height: size.width - 50)
                        .padding(.vertical, size.height < 700 ? 10 : 30)
                    
                    PlayerView(viewModel: viewModel)
                }
                .padding(.top, safeArea.top + (safeArea.bottom == 0 ? 10 : 0))
                .padding(.bottom, safeArea.bottom == 0 ? 10 : safeArea.bottom)
                .padding(.horizontal, 18)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .clipped()
            }
            .ignoresSafeArea(.container, edges: .all)
        }
        .onAppear {
            viewModel.setupAudio()
        }
        .onReceive(Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()) { _ in
            viewModel.updateProgress()
        }
    }
    
    var imageView: some View {
        GeometryReader {
            let size = $0.size
            AsyncImage(url: URL(string: viewModel.song.artworkUrl100)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
            }
            .frame(width: size.width, height: size.height)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
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
        }
        .padding(.top, 16)
        .padding(.bottom, 8)
    }
}
