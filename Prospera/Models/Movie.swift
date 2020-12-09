//
//  Movie.swift
//  Prospera
//
//  Created by Assaf Tayouri on 08/12/2020.
//

import Foundation

// Class that represents the basic information of a movie
class Movie: Decodable {
    let title: String
    let year: Int
    let movieId: String
    let imageUrl: String
    var isFavorite: Bool
    
    enum MovieCodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case movieId = "imdbID"
        case imageUrl = "Poster"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: MovieCodingKeys.self)
        
        self.title = try values.decode(String.self, forKey: .title)
        
        let yearStr = try values.decode(String.self, forKey: .year)
        self.year = Int(yearStr) ?? 0
        
        self.movieId = try values.decode(String.self, forKey: .movieId)
        
        self.imageUrl = try values.decode(String.self, forKey: .imageUrl)
        
        self.isFavorite = false
    }
}
