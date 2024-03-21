//
//  SongViewModel.swift
//  MusicLibrary
//
//  Created by Alibek Shakirov on 20.03.2024.
//

import Foundation

class SongViewModel: ObservableObject {
    
    @Published var songs: [Song] = [Song]()
    @Published var searchItem: String = ""
    
    @Published var state: FetchState = .good
    
    let limit: Int = 20
    var page: Int = 0
    
    let service = APIService()
    
    func fetchSongs(for search: String) {
        
        guard !searchItem.isEmpty else { return }
        
        guard state == FetchState.good else { return }
        
        state = .isLoading
        
        service.fetchSong(searchItem: searchItem, page: page, limit: limit) { [weak self]  result in
            DispatchQueue.main.async {
                switch result {
                case .success(let results):
                    for song in results.results {
                        self?.songs.append(song)
                    }
                    self?.page += 1
                    self?.state = (results.results.count == self?.limit) ? .good : .loadedAll
                case .failure(let error):
                    self?.state = .error("Can't load: \(error.localizedDescription)")
                }
            }
        }
    }
}
