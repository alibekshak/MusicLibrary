//
//  AlbumViewModel.swift
//  MusicLibrary
//
//  Created by Alibek Shakirov on 19.03.2024.
//

import Foundation
import Combine

enum EntityType: String {
    case album
    case song
}

class AlbumViewModel: ObservableObject {
    
    @Published var searchItem: String = ""
    @Published var albums: [Album] = [Album]()
    
    @Published var state: State = .good 
    
    let limit: Int = 20
    var page: Int = 0
    
    var bag = Set<AnyCancellable>()
    
    let service:  APIService
    
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
        
        guard state == State.good else { return }
        
        state = .isLoading
        
        service.fetchAlbum(searchItem: searchItem, page: page, limit: limit) { [weak self]  result in
            DispatchQueue.main.async {
                switch result {
                case .success(let results):
                    for album in results.results {
                        self?.albums.append(album)
                    }
                    self?.page += 1
                    self?.state = (results.results.count == self?.limit) ? .good : .loadedAll
                case .failure(let error):
                    self?.state = .error("Couldn't load: \(error.localizedDescription)")
                }
            }
        }
    }
}
