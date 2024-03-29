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
    let setupGroup = DispatchGroup()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        self.rootController = launchScreen()
        window.rootViewController = rootController
    }
    
    private func launchScreen() -> UIViewController {
        let viewController = UIHostingController(rootView: LaunchScreen())
        
        setupGroup.notify(queue: .main) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.rootController = self.albumScreen()
                self.window.rootViewController = self.rootController
                
                self.rootController.view.alpha = 0
                UIView.animate(withDuration: 1) {
                    self.rootController.view.alpha = 1
                }
            }
        }
        return viewController
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
        
        let albumSongController = UIHostingController(rootView: SongsInAlbumView(viewModel: viewModel))
        
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
        
        playAudioController.modalTransitionStyle = .crossDissolve
        playAudioController.modalPresentationStyle = .fullScreen
        
        return playAudioController
    }
}
