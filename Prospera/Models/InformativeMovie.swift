//
//  InformativeMovie.swift
//  Prospera
//
//  Created by Assaf Tayouri on 08/12/2020.
//

import Foundation

// Class that represents the extend information of a movie
class InformativeMovie: Movie {
    let runtime: String
    let genres: [String]
    let rating: Float
    let director: String
    let plot: String
    
    enum InformativeMovieCodingKeys: String, CodingKey {
        case runtime = "Runtime"
        case genres = "Genre"
        case rating  = "imdbRating"
        case director = "Director"
        case plot = "Plot"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: InformativeMovieCodingKeys.self)
        
        self.runtime = try values.decode(String.self, forKey: .runtime)
        
        let genresStr = try values.decode(String.self, forKey: .genres)
        self.genres = genresStr.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        
        let ratingStr = try values.decode(String.self, forKey: .rating)
        self.rating = (Float(ratingStr)?.rounded() ?? 0) / 2
        
        let directorsStr = try values.decode(String.self, forKey: .director)
        self.director = directorsStr.split(separator: ",")[0].trimmingCharacters(in: .whitespacesAndNewlines)
        
        self.plot = try values.decode(String.self, forKey: .plot)
        
        try super.init(from: decoder)
    }
    
    
}
