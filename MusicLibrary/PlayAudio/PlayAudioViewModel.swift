//
//  PlayAudioViewModel.swift
//  MusicLibrary
//
//  Created by Alibek Shakirov on 26.03.2024.
//

import Foundation
import AVFAudio

class PlayAudioViewModel: ObservableObject {
    enum Event {
        case dismiss
    }
    var onEvent: ((Event) -> Void)?
    
    @Published var song: Song
    @Published var player: AVAudioPlayer?
    @Published var totalTime: TimeInterval = 0.0
    @Published var volume: Float = 0.5
    @Published var currentTime: TimeInterval = 0.0
    @Published var isPlaying: Bool = false
    
    @Published var loadingData: Bool = false
    
    init(song: Song) {
        self.song = song
        print("init song: \(song)")
    }
    
    func setupAudio() {
        DispatchQueue.main.async {
            self.loadingData = true
        }
        
        guard let url = URL(string: song.previewURL) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error loading: \(error)")
                    return
                }
                
                guard let data = data else { return }
                
                do {
                    self.player = try AVAudioPlayer(data: data)
                    self.player?.prepareToPlay()
                    self.totalTime = self.player?.duration ?? 0.0
                    self.player?.volume = self.volume
                    
                    DispatchQueue.main.async {
                        self.loadingData = false
                    }
                } catch {
                    print("Error audio player: \(error)")
                }
            }
        }
        .resume()
    }
    
    func increaseVolume() {
        guard let player = player else { return }
        let newVolume = min(player.volume + 0.1, 1.0)
        adjustVolume(to: newVolume)
    }
    
    func decreaseVolume() {
        guard let player = player else { return }
        let newVolume = max(player.volume - 0.1, 0.0)
        adjustVolume(to: newVolume)
    }
    
    func adjustVolume(to value: Float) {
        guard let player = player else { return }
        player.volume = value
        volume = value
    }
    
    func playAudio() {
        player?.play()
        isPlaying = true
    }
    
    func stopAudio() {
        player?.pause()
        isPlaying = false
    }
    
    func updateProgress() {
        guard let player = player else { return }
        currentTime = player.currentTime
        let epsilon: TimeInterval = 0.1
        if player.currentTime + epsilon >= totalTime {
            isPlaying = false
        }
    }
    
    func seekAudio(to time: TimeInterval) {
        player?.currentTime = time
        if time >= totalTime {
            isPlaying = false
        }
    }
    
    func timeString(time: TimeInterval) -> String {
        let minute = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minute, seconds)
    }
    
    func seekAudioBy(seconds: TimeInterval) {
        let newTime = currentTime + seconds
        if newTime < 0 {
            seekAudio(to: 0)
        } else if newTime > totalTime {
            seekAudio(to: totalTime)
        } else {
            seekAudio(to: newTime)
        }
    }
}
