//
//  MovieRequest.swift
//  Prospera
//
//  Created by Assaf Tayouri on 08/12/2020.
//

import Foundation

enum MovieRequestType {
    
    private struct MovieRequestConsts {
        static let baseUrl = "http://www.omdbapi.com"
        static let secret = "dce24c91"
        static let secretKey = "apikey"
        static let typeKey = "type"
        static let searchKey = "s"
        static let imdbIdKey = "i"
        static let movieTypeKey = "movie"
    }
    
    case search(searchStr: String)
    case id(imdbId: String)
    
    var request: URLRequest {
        
        var urlQueryItems = [URLQueryItem(name: MovieRequestConsts.secretKey, value: MovieRequestConsts.secret)]
        
        switch self {
            case .search(let searchStr):
                urlQueryItems.append(contentsOf:
                                        [
                                            URLQueryItem(name: MovieRequestConsts.secretKey, value: searchStr),
                                            URLQueryItem(name: MovieRequestConsts.typeKey, value: MovieRequestConsts.movieTypeKey)
                                        ])
                
            case .id(let imdbId):
                urlQueryItems.append(contentsOf:
                                        [
                                            URLQueryItem(name: MovieRequestConsts.imdbIdKey, value: imdbId),
                                        ])
        }
        
        var urlComponents = URLComponents(string: MovieRequestConsts.baseUrl)!
        urlComponents.queryItems = urlQueryItems
        
        return URLRequest(url: urlComponents.url!)
    }
}
