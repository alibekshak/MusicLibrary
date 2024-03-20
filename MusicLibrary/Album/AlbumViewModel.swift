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
        
        state = .isLoading
        let url = creatURL(for: searchItem)
        
        fetch(type: AlbumResponse.self, url: url) { [weak self]  result in
            DispatchQueue.main.async {
                switch result {
                case .success(let results):
                    for album in results.results {
                        self?.albums.append(album)
                    }
                    self?.page += 1
                    self?.state = (results.results.count == self?.limit) ? .good : .loadedAll
                case .failure(let error):
                    self?.state = .error("Can't load: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func fetch<T: Decodable>(type: T.Type, url: URL?, completion: @escaping (Result<T, APIError>) -> Void) {
        
        guard let url = url else {
            let error = APIError.badURL
            completion(Result.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: url) { date, response, error in
            if let error = error as? URLError {
                completion(Result.failure(APIError.urlSession(error)))
            } else if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                completion(Result.failure(APIError.badResponse(response.statusCode)))
            } else if let date = date {
                
                do {
                    let result = try JSONDecoder().decode(type, from: date)
                    completion(Result.success(result))
                } catch {
                    completion(Result.failure(.decoding(error as? DecodingError)))
                }
            }
        }.resume()
    }
    
    func creatURL(for searchItem: String, type: EntityType = .album) -> URL? {
        let baseURL = "https://itunes.apple.com/search"
        let offset = page * limit
        
        let queryItem = [URLQueryItem(name: "term", value: searchItem),
                         URLQueryItem(name: "entity", value: type.rawValue),
                         URLQueryItem(name: "limit", value: String(limit)),
                         URLQueryItem(name: "offset", value: String(offset)),
        ]

        
        var component = URLComponents(string: baseURL)
        component?.queryItems = queryItem
        return component?.url
    }
}
