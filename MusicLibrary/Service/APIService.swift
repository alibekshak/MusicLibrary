//
//  APIService.swift
//  MusicLibrary
//
//  Created by Alibek Shakirov on 20.03.2024.
//

import Foundation

class APIService {
    
    let baseURL: String = API.baseURP
    
    func fetchAlbum(searchItem: String, page: Int, limit: Int, completion: @escaping (Result<AlbumResponse, APIError>) -> Void) {
        let url = creatURL(for: searchItem, type: .album, page: page, limit: limit)
        NetworkManager.fetch(type: AlbumResponse.self, url: url, completion: completion)
    }
    
    func fetchSong(searchItem: String, page: Int, limit: Int, completion: @escaping (Result<SongResponse, APIError>) -> Void) {
        let url = creatURL(for: searchItem, type: .song, page: page, limit: limit)
        NetworkManager.fetch(type: SongResponse.self, url: url, completion: completion)
    }
    
    func fetchSongs(for albumID: Int, completion: @escaping(Result<SongResponse, APIError>) -> Void) {
        let url = createURL(for: albumID, type: .song)
        NetworkManager.fetch(type: SongResponse.self, url: url, completion: completion)
    }
    
    func creatURL(for searchItem: String, type: EntityType, page: Int?, limit: Int?) -> URL? {
        let urlSearch = baseURL + "search"
        
        var queryItems = [URLQueryItem(name: "term", value: searchItem),
                         URLQueryItem(name: "entity", value: type.rawValue),
        ]
        
        if let page = page, let limit = limit {
            let offset = page * limit
            queryItems.append(URLQueryItem(name: "limit", value: String(limit)))
            queryItems.append(URLQueryItem(name: "offset", value: String(offset)))
        }

        var component = URLComponents(string: urlSearch)
        component?.queryItems = queryItems
        return component?.url
    }
    
    func createURL(for id: Int,type: EntityType) -> URL? {
        let urlLookup = baseURL + "lookup"
        
        let queryItems = [URLQueryItem(name: "id", value: String(id)),
                          URLQueryItem(name: "entity", value: type.rawValue)]
        
        var components = URLComponents(string: urlLookup)
        components?.queryItems = queryItems
        return components?.url
    }
}
