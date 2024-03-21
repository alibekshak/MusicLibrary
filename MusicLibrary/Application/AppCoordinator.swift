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
        let viewModel = AlbumViewModel(service: APIService())
        let controller = UIHostingController(rootView: AlbumView(viewModel: viewModel))
        
        viewModel.onEvent = { [weak controller, weak self] event in
            guard let self else { return }
            switch event {
            case let .song(albumID):
                controller?.present(albumSongsScreen(albumID: albumID), animated: true)
            }
        }
        
        let nc = UINavigationController(rootViewController: controller)
        
        return nc
    }
    
    private func albumSongsScreen(albumID: Int) -> UIViewController {
        let viewModel = SongForAlbumViewModel(albumID: albumID, service: APIService())
        
        let albumSongViewController = UIHostingController(rootView: SongsInAlbumView(songsViewModel: viewModel))
        
        viewModel.onEvent = { [weak self, weak albumSongViewController] event in
            guard let self = self else { return }
            switch event {
            case .dismiss:
                albumSongViewController?.dismiss(animated: true)
            }
        }
        albumSongViewController.modalPresentationStyle = .fullScreen
        return albumSongViewController
    }
}
