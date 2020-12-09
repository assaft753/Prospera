//
//  MovieRequestType.swift
//  Prospera
//
//  Created by Assaf Tayouri on 08/12/2020.
//

import Foundation

// Enum that responsible for creating the desired movie request type
// (by search or by movie id)
enum MovieRequestType {
    
    private struct MovieRequestConsts {
        static let baseUrl = "https://www.omdbapi.com"
        static let secret = "dce24c91"
        static let secretKey = "apikey"
        static let typeKey = "type"
        static let searchKey = "s"
        static let movieIdKey = "i"
        static let movieTypeKey = "movie"
        static let plotTypeKey = "plot"
        static let fullPlotTypeKey = "full"
    }
    
    case search(searchStr: String)
    case id(movieId: String)
    
    var request: URLRequest {
        
        var urlQueryItems = [URLQueryItem(name: MovieRequestConsts.secretKey, value: MovieRequestConsts.secret)]
        
        switch self {
            case .search(let searchStr):
                urlQueryItems.append(contentsOf:
                                        [
                                            URLQueryItem(name: MovieRequestConsts.searchKey, value: searchStr),
                                            URLQueryItem(name: MovieRequestConsts.typeKey, value: MovieRequestConsts.movieTypeKey)
                                        ])
                
            case .id(let movieId):
                urlQueryItems.append(contentsOf: [
                    URLQueryItem(name: MovieRequestConsts.movieIdKey, value: movieId),
                    URLQueryItem(name: MovieRequestConsts.plotTypeKey, value: MovieRequestConsts.fullPlotTypeKey)
                ])
        }
        
        var urlComponents = URLComponents(string: MovieRequestConsts.baseUrl)!
        urlComponents.queryItems = urlQueryItems
        
        return URLRequest(url: urlComponents.url!)
    }
}
