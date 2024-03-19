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
        let viewModel = AlbumViewModel()
        let controller = UIHostingController(rootView: AlbumView(viewModel: viewModel))
        
        let nc = UINavigationController(rootViewController: controller)
        
        return nc
    }
}
