//
//  AlbumViewModel.swift
//  MusicLibrary
//
//  Created by Alibek Shakirov on 19.03.2024.
//

import Foundation
import Combine

class AlbumViewModel: ObservableObject {
    
    @Published var searchItem: String = ""
    @Published var albums: [Album] = [Album]()
    
    @Published var state: State = .good 
    
    let limit: Int = 20
    var page: Int = 0
    
    var bag = Set<AnyCancellable>()
    
    init() {
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
        
        let offset = page * limit
        
        guard let url = URL(string: "https://itunes.apple.com/search?term=\(searchItem)&entity=album&limit=\(limit)&offset=\(offset)") else { return }
        
        state = .isLoading
        
        URLSession.shared.dataTask(with: url) { [weak self] date, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self?.state = .error("Can't load: \(error.localizedDescription)")
                }
            } else if let date = date {
                
                do {
                    let result = try JSONDecoder().decode(AlbumResponse.self, from: date)
                    DispatchQueue.main.async {
                        for album in result.results {
                            self?.albums.append(album)
                        }
                        self?.page += 1
                        self?.state = (result.results.count == self?.limit) ? .good : .loadedAll
                    }
                    
                } catch {
                    print("Error: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        self?.state = .error("Can't get date: \(error.localizedDescription)")
                    }
                }
            }
        }.resume()
    }
}
