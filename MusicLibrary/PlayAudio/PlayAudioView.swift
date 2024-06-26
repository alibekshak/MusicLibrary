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
                    
                    PlayerView(size)
                }
                .padding(.top, safeArea.top + (safeArea.bottom == 0 ? 10 : 0))
                .padding(.bottom, safeArea.bottom == 0 ? 10 : safeArea.bottom)
                .padding(.horizontal, 18)
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
        let epsilon: TimeInterval = 0.1
        if player.currentTime + epsilon >= viewModel.totalTime {
            isPlaying = false
        }
    }
    
    private func seekAudio(to time: TimeInterval) {
        viewModel.player?.currentTime = time
        if time >= viewModel.totalTime {
            isPlaying = false
        }
    }
    
    private func timeString(time: TimeInterval) -> String {
        let minute = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minute, seconds)
    }
    
    private func seekAudioBy(seconds: TimeInterval) {
        let newTime = currentTime + seconds
        if newTime < 0 {
            seekAudio(to: 0)
        } else if newTime > viewModel.totalTime {
            seekAudio(to: viewModel.totalTime)
        } else {
            seekAudio(to: newTime)
        }
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
                    
                    MusicSliderView(value: Binding(get: {
                        currentTime
                    }, set: { newValue in
                        seekAudio(to: newValue)
                    }), range: 0...viewModel.totalTime)
                    .frame(height: 7)
                    
                    HStack {
                        Text(timeString(time: currentTime))
                        Spacer()
                        Text(timeString(time: viewModel.totalTime))
                    }
                }
                .frame(height: size.height / 2.5, alignment: .top)
                
                HStack(spacing: size.width * 0.2) {
                    Button {
                        seekAudioBy(seconds: -10)
                    } label: {
                        Image(systemName: "gobackward.10")
                            .font(size.height < 300 ? .system(size: 25) : .system(size: 15))
                    }
                    
                    Button {
                        isPlaying ? stopAudio() : playAudio()
                    } label: {
                        Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                            .font(size.height < 300 ? .system(size: 60) : .system(size: 30))
                    }
                    
                    Button {
                        seekAudioBy(seconds: 10)
                    } label: {
                        Image(systemName: "goforward.10")
                            .font(size.height < 300 ? .system(size: 25) : .system(size: 15))
                    }
                }
                .padding(.bottom)
                .foregroundColor(.white)
                
                VStack(spacing: spacing) {
                    HStack(spacing: 15) {
                        Button {
                            viewModel.decreaseVolume()
                        } label: {
                            Image(systemName: "speaker.fill")
                        }
                        
                        SliderVolumeView(percentage: Binding(
                            get: {
                                viewModel.volume
                            },
                            set: { newValue in
                                viewModel.volume = newValue
                                viewModel.adjustVolume(to: newValue)
                            }
                        ))
                        .frame(height: 7)
                        
                        Button {
                            viewModel.increaseVolume()
                        } label: {
                            Image(systemName: "speaker.wave.3.fill")
                        }
                    }
                }
                .foregroundColor(.white)
            }
        }
    }
}
