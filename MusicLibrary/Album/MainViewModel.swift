//
//  MainView.swift
//  MusicLibrary
//
//  Created by Alibek Shakirov on 19.03.2024.
//

import Foundation
import Combine

// https://itunes.apple.com/search?term=jack+johnson&entity=album&limit=5&offset=10

class MainViewModel: ObservableObject {
    
    enum Event {
        case albumForSongs(Album)
        case playAudio(Song)
    }
    var onEvent: ((Event) -> Void)?
    
    @Published var searchItem: String = ""
    @Published var albums: [Album] = [Album]()
    @Published var state: FetchState = .good
    @Published var songs: [Song] = [Song]()
    
    let limit: Int = 20
    var page: Int = 0
    
    let service:  APIService
    
    var bag = Set<AnyCancellable>()
    
    init(service: APIService) {
        self.service = service
        $searchItem
            .removeDuplicates()
            .dropFirst()
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { [weak self] item in
                self?.state = .good
                self?.albums = []
                self?.page = 0
                self?.fetchAlbums(for: item)
            }.store(in: &bag)
        
        $searchItem
            .removeDuplicates()
            .dropFirst()
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { [weak self] term in
                self?.state = .good
                self?.songs = []
                self?.page = 0
                self?.fetchSong(for: term)
            }.store(in: &bag)
    }
    
    func loadMoreAlbum() {
        fetchAlbums(for: searchItem)
    }
    
    func loadMoreSong() {
        fetchSong(for: searchItem)
    }
    
    func fetchSong(for searchTerm: String){
        guard !searchTerm.isEmpty else { return }
        
        guard state == .good else { return }
        
        state = .isLoading
        
        service.fetchSong(searchItem: searchItem, page: page, limit: limit){ [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let result):
                    for song in result.results{
                        self?.songs.append(song)
                        
                        self?.page += 1
                        self?.state = (result.results.count == self?.limit) ? .good : .loadedAll
                    }
                case .failure(let error):
                    self?.state = .error("Could not get data: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func fetchAlbums(for search: String) {
        guard !search.isEmpty else { return }
        
        guard state == .good else { return }
        
        state = .isLoading
        
        service.fetchAlbum(searchItem: searchItem, page: page, limit: limit) { [weak self]  result in
            DispatchQueue.main.async {
                switch result {
                case .success(let result):
                    for album in result.results {
                        self?.albums.append(album)
                        self?.page += 1
                        self?.state = (result.results.count == self?.limit) ? .good : .loadedAll
                    }
                case .failure(let error):
                    self?.state = .error("Couldn't load: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func showAlbumSongs(album: Album) {
        onEvent?(.albumForSongs(album))
    }
}
