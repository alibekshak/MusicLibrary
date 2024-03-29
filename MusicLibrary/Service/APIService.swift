//
//  APIService.swift
//  MusicLibrary
//
//  Created by Alibek Shakirov on 20.03.2024.
//

import Foundation

class APIService {
    
    func fetchAlbum(searchItem: String, page: Int, limit: Int, completion: @escaping (Result<AlbumResponse, APIError>) -> Void) {
        let url = creatURL(for: searchItem, type: .album, page: page, limit: limit)
        fetch(type: AlbumResponse.self, url: url, completion: completion)
    }
    
    func fetchSong(searchItem: String, page: Int, limit: Int, completion: @escaping (Result<SongResponse, APIError>) -> Void) {
        let url = creatURL(for: searchItem, type: .song, page: page, limit: limit)
        fetch(type: SongResponse.self, url: url, completion: completion)
    }
    
    func fetchSongs(for albumID: Int, completion: @escaping(Result<SongResponse, APIError>) -> Void) {
        let url = createURL(for: albumID, type: .song)
        fetch(type: SongResponse.self, url: url, completion: completion)
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
    
    func creatURL(for searchItem: String, type: EntityType, page: Int?, limit: Int?) -> URL? {
        let baseURL = "https://itunes.apple.com/search"
        
        var queryItems = [URLQueryItem(name: "term", value: searchItem),
                         URLQueryItem(name: "entity", value: type.rawValue),
        ]
        
        if let page = page, let limit = limit {
            let offset = page * limit
            queryItems.append(URLQueryItem(name: "limit", value: String(limit)))
            queryItems.append(URLQueryItem(name: "offset", value: String(offset)))
        }

        
        var component = URLComponents(string: baseURL)
        component?.queryItems = queryItems
        return component?.url
    }
    
    func createURL(for id: Int,type: EntityType) -> URL? {
        let baseURL = "https://itunes.apple.com/lookup"
        
        let queryItems = [URLQueryItem(name: "id", value: String(id)),
                          URLQueryItem(name: "entity", value: type.rawValue)]
        
        var components = URLComponents(string: baseURL)
        components?.queryItems = queryItems
        return components?.url
    }
}
