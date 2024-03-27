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
    
    @State private var isPlaying = false
    @State private var currentTime: TimeInterval = 0.0
    @State private var animationContent: Bool = false
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            let safeArea = $0.safeAreaInsets
            
            ZStack {
                
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .overlay {
                        Rectangle()
                            .fill(.gray)
                            .blur(radius: 55)
                    }
                
                VStack(spacing: 15) {
                    navigationBar
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
                            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                    }
                    .frame(height: size.width - 50)
                    .padding(.vertical, size.height < 700 ? 10 : 30)
                    
                    PlayerView(size)
                    
                }
                .padding(.top, safeArea.top + (safeArea.bottom == 0 ? 10 : 0))
                .padding(.bottom, safeArea.bottom == 0 ? 10 : safeArea.bottom)
                .padding(.horizontal, 25)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .clipped()
            }
            .ignoresSafeArea(.container, edges: .all)
        }
        .onAppear(perform: {
            viewModel.setupAudio()
        })
        .onReceive(Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()) { _ in
            updateProgress()
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
    
    private func playAudio() {
        viewModel.player?.play()
        isPlaying = true
    }
    
    private func stopAudio() {
        viewModel.player?.pause()
        isPlaying = false
    }
    
    private func updateProgress() {
        guard let player = viewModel.player else { return }
        currentTime = player.currentTime
    }
    
    private func seekAudio(to time: TimeInterval) {
        viewModel.player?.currentTime = time
    }
    
    private func timeString(time: TimeInterval) -> String {
        let minute = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minute, seconds)
    }
    
    @ViewBuilder
    func PlayerView(_ mainSize: CGSize) -> some View {
        GeometryReader {
            let size = $0.size
            let spacing = size.height * 0.04
            
            VStack(spacing: spacing) {
                VStack(spacing: spacing) {
                    HStack(alignment: .center, spacing: 15) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(viewModel.song.trackName)
                                .font(.title3)
                                .fontWeight(.semibold)
                            
                            Text(viewModel.song.artistName)
                                .font(.callout)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    Slider(value: Binding(get: {
                        currentTime
                    }, set: { newValue in
                        seekAudio(to: newValue)
                    }), in: 0...viewModel.totalTime)
                    .accentColor(.white)
                    
                    HStack {
                        Text(timeString(time: currentTime))
                        Spacer()
                        Text(timeString(time: viewModel.totalTime))
                    }
                }
                .frame(height: size.height / 2.5, alignment: .top)
                
                HStack(spacing: size.width * 0.2) {
                    Button {
                        
                    } label: {
                        Image(systemName: "backward.circle.fill")
                            .font(size.height < 300 ? .system(size: 45) : .system(size: 30))
                    }
                    
                    Button {
                        isPlaying ? stopAudio() : playAudio()
                    } label: {
                        Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                            .font(size.height < 300 ? .system(size: 65) : .system(size: 50))
                    }
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "forward.circle.fill")
                            .font(size.height < 300 ? .system(size: 45) : .system(size: 30))
                    }
                }
                .padding(.top, 24)
                .foregroundColor(.white)
            }
        }
    }
}

extension View {
    var deviceCornerRadius: CGFloat {
        let key = "_displayCornerRadius"
        
        if let screen = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.screen {
            if let cornerRadious = screen.value(forKey: key) as? CGFloat {
                return cornerRadious
            }
            return 0
        }
        return 0
    }
}
