//
//  SongForAlbumViewModel.swift
//  MusicLibrary
//
//  Created by Alibek Shakirov on 21.03.2024.
//

import Foundation

class SongForAlbumViewModel: ObservableObject{
    enum Event {
        case dismiss
        case playAudio(Song)
    }
    var onEvent: ((Event) -> Void)?
    
    @Published var album: Album
    @Published  var songs = [Song]()
    @Published var state: FetchState = .good
    
    let service:  APIService
    
    init(album: Album, service: APIService) {
        self.album = album
        self.service = service
        print("init album \(album)")
        self.fetch()
    }
    
    func fetch() {
        fetchSongs(for: album.id)
    }
    
    private func fetchSongs(for albumID: Int) {
        service.fetchSongs(for: albumID) {[weak self]  result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let results):
                        var songs = results.results
                        
                        if results.resultCount > 0 {
                            _ = songs.removeFirst()
                        }
                        
                        self?.songs = songs
                        self?.state = .good
                        print("fetched \(results.resultCount) songs for albumID: \(albumID)")
                        
                    case .failure(let error):
                        print("Could not load: \(error)")
                        self?.state = .error(error.localizedDescription)
                }
            }
        }
    }
}
