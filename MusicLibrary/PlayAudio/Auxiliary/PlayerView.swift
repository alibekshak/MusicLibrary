//
//  PlayerView.swift
//  MusicLibrary
//
//  Created by Alibek Shakirov on 20.08.2024.
//

import SwiftUI

struct PlayerView: View {
    
    @StateObject var viewModel: PlayAudioViewModel
    
    var body: some View {
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
                        viewModel.currentTime
                    }, set: { newValue in
                        viewModel.seekAudio(to: newValue)
                    }), range: 0...viewModel.totalTime)
                    .frame(height: 7)
                    
                    HStack {
                        Text(viewModel.timeString(time: viewModel.currentTime))
                        Spacer()
                        Text(viewModel.timeString(time: viewModel.totalTime))
                    }
                }
                .frame(height: size.height / 2.5, alignment: .top)
                
                HStack(spacing: size.width * 0.2) {
                    Button {
                        viewModel.seekAudioBy(seconds: -10)
                    } label: {
                        Image(systemName: "gobackward.10")
                            .font(size.height < 300 ? .system(size: 25) : .system(size: 15))
                    }
                    
                    Button {
                        viewModel.isPlaying ? viewModel.stopAudio() : viewModel.playAudio()
                    } label: {
                        Image(systemName: viewModel.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                            .font(size.height < 300 ? .system(size: 60) : .system(size: 30))
                    }
                    
                    Button {
                        viewModel.seekAudioBy(seconds: 10)
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

