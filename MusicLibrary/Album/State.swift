//
//  State.swift
//  MusicLibrary
//
//  Created by Alibek Shakirov on 19.03.2024.
//

import Foundation

enum State: Comparable {
    case good
    case isLoading
    case loadedAll
    case noResults
    case error(String)
}
