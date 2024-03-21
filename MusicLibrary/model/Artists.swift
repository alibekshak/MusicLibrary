//
//  Artists.swift
//  MusicLibrary
//
//  Created by Alibek Shakirov on 21.03.2024.
//

import Foundation

struct Artists:  Hashable {
    var image: String
    var name: String
    var term: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(image)
        hasher.combine(name)
        hasher.combine(term)
    }
    
    static func == (lhs: Artists, rhs: Artists) -> Bool {
        return lhs.image == rhs.image && lhs.name == rhs.name && lhs.term == rhs.term
    }
}
