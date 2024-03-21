//
//  AlbumViewModel.swift
//  MusicLibrary
//
//  Created by Alibek Shakirov on 19.03.2024.
//

import Foundation
import Combine

// https://itunes.apple.com/search?term=jack+johnson&entity=album&limit=5&offset=10

class AlbumViewModel: ObservableObject {
    
    enum Event {
        case song(Int)
    }
    var onEvent: ((Event) -> Void)?
    
    @Published var searchItem: String = ""
    @Published var albums: [Album] = [Album]()
    @Published var state: FetchState = .good
    
    let limit: Int = 20
    var page: Int = 0
    
    let service:  APIService
    
    var bag = Set<AnyCancellable>()
    

    
    init(service: APIService) {
        self.service = service
        $searchItem
            .dropFirst()
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { [weak self] item in
                self?.state = .good
                self?.albums = []
                self?.fetchAlbums(for: item)
            }.store(in: &bag)
    }
    
    func loadMore() {
        fetchAlbums(for: searchItem)
    }
    
    func fetchAlbums(for search: String) {
        
        guard !searchItem.isEmpty else { return }
        
        guard state == FetchState.good else { return }
        
        state = .isLoading
        
        service.fetchAlbum(searchItem: searchItem, page: page, limit: limit) { [weak self]  result in
            DispatchQueue.main.async {
                switch result {
                case .success(let result):
                    for album in result.results {
                        self?.albums.append(album)
                    }
                    self?.page += 1
                    self?.state = (result.results.count == self?.limit) ? .good : .loadedAll
                case .failure(let error):
                    self?.state = .error("Couldn't load: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func showAlbumSongs(songID: Int) {
        onEvent?(.song(songID))
    }
}
