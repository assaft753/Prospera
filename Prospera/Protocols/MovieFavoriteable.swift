//
//  MovieFavoriteable.swift
//  Prospera
//
//  Created by Assaf Tayouri on 09/12/2020.
//

import Foundation

// Protocol (function as delegate) for set favorite movie event
protocol MovieFavoriteable: class {
    func addFavoriteMovie(with movieId: String)
    func removeFavoriteMovie(with movieId: String)
}
