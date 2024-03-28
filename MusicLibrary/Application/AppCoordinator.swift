//
//  AppCoordinator.swift
//  MusicLibrary
//
//  Created by Alibek Shakirov on 19.03.2024.
//

import Foundation
import UIKit
import SwiftUI

class AppCoordinator {
    var rootController: UIViewController!
    var window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        self.rootController = albumScreen()
        window.rootViewController = rootController
    }
    
    private func albumScreen() -> UIViewController {
        let viewModel = MainViewModel(service: APIService())
        let controller = UIHostingController(rootView: MainView(viewModel: viewModel))
        
        viewModel.onEvent = { [weak controller, weak self] event in
            guard let self else { return }
            switch event {
            case let .albumForSongs(album):
                controller?.present(albumSongsScreen(album: album), animated: true)
            case let .playAudio(song):
                controller?.present(playAudioScreen(song: song), animated: true)
            }
        }
        
        let nc = UINavigationController(rootViewController: controller)
        
        return nc
    }
    
    private func albumSongsScreen(album: Album) -> UIViewController {
        let viewModel = SongForAlbumViewModel(album: album, service: APIService())
        
        let albumSongController = UIHostingController(rootView: SongsInAlbumView(songsViewModel: viewModel))
        
        viewModel.onEvent = { [weak self, weak albumSongController] event in
            guard let self = self else { return }
            switch event {
            case .dismiss:
                albumSongController?.dismiss(animated: true)
            case let .playAudio(song):
                albumSongController?.present(playAudioScreen(song: song), animated: true)
            }
        }
        albumSongController.modalPresentationStyle = .fullScreen
        return albumSongController
    }
    
    private func playAudioScreen(song: Song) -> UIViewController {
        let viewModel = PlayAudioViewModel(song: song)
        
        let playAudioController = UIHostingController(rootView: PlayAudioView(viewModel: viewModel))
        
        viewModel.onEvent = { [weak self, weak playAudioController] event in
            guard let self = self else { return }
            switch event {
            case .dismiss:
                playAudioController?.dismiss(animated: true)
            }
        }
        playAudioController.modalPresentationStyle = .fullScreen
        return playAudioController
    }
}
