//
//  EntityType.swift
//  MusicLibrary
//
//  Created by Alibek Shakirov on 21.03.2024.
//

import Foundation

enum EntityType: String, Identifiable, CaseIterable {
    case album
    case song
    
    var id: String {
        self.rawValue
    }
    
    func name() -> String {
        switch self {
            case .album:
                return "Albums"
            case .song:
                return "Songs"
        }
    }
}
