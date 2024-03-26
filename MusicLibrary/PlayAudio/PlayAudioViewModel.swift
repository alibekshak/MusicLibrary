//
//  PlayAudioViewModel.swift
//  MusicLibrary
//
//  Created by Alibek Shakirov on 26.03.2024.
//

import Foundation

class PlayAudioViewModel: ObservableObject {
    @Published var song: Song
    
    init(song: Song) {
        self.song = song
        print("init song: \(song)")
    }
}
