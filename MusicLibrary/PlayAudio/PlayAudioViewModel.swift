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
    
    init(song: Song) {
        self.song = song
        print("init song: \(song)")
    }
    
    func setupAudio() {
        guard let url = URL(string: song.previewURL) else {
            print("Invalid URL")
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
                } catch {
                    print("Error audio player: \(error)")
                }
            }
        }.resume()
    }
}
