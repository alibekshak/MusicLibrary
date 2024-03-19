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
    
    let limit: Int = 15
    var page: Int = 0
    
    var bag = Set<AnyCancellable>()
    
    init() {
        $searchItem
            .dropFirst()
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { [weak self] item in
            self?.fetchAlbums(for: item)
        }.store(in: &bag)
    }
    
    func loadMore() {
        fetchAlbums(for: searchItem)
    }
    
    func fetchAlbums(for search: String) {
        
        guard !searchItem.isEmpty else { return }
        
        let offset = page * limit
        
        guard let url = URL(string: "https://itunes.apple.com/search?term=\(searchItem)&entity=album&limit=\(limit)&offset=\(offset)") else { return }
        
        URLSession.shared.dataTask(with: url) { date, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else if let date = date {
                
                do {
                    let result = try JSONDecoder().decode(AlbumResponse.self, from: date)
                    DispatchQueue.main.async {
                        for album in result.results {
                            self.albums.append(album)
                        }
                        self.page += 1
                    }
                    
                } catch {
                    print("Error: \(error.localizedDescription)")
                }
                
            }
        }.resume()
    }
}
