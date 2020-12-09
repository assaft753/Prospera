//
//  MovieService.swift
//  Prospera
//
//  Created by Assaf Tayouri on 08/12/2020.
//

import Foundation

// Singleton Service for actions of movies
class MovieService {
    
    // MARK:- Static properties
    private static var instance: MovieService!
    
    // lazily initialization of the singleton
    static var shared: MovieService {
        instance = instance ?? MovieService()
        return instance
    }
    
    // MARK:- Properties
    private var favoriteMovies: Set<String>
    
    private let localStorageFavoriteMoviesKey = "favoriteMovies"
    
    // MARK:- Constructor
    private init() {
        self.favoriteMovies = Set<String>(LocalStorage().read(for: localStorageFavoriteMoviesKey) ?? [])
    }
    
    // MARK:- Methods
    func addMovieToFavorites(_ movieId: String) {
        favoriteMovies.insert(movieId)
        LocalStorage().store(for: localStorageFavoriteMoviesKey, value: favoriteMovies.toArray())
    }
    
    func removeMovieFromFavorites(_ movieId: String) {
        favoriteMovies.remove(movieId)
        LocalStorage().store(for: localStorageFavoriteMoviesKey, value: favoriteMovies.toArray())
    }
    
    func fetchMovieBy(movieId: String, completion: @escaping (InformativeMovie?) -> Void) {
        MoviesFetcher().fetch(for: .id(movieId: movieId)) { [unowned self] in
            if let data = $0,
               let informativeMovie = try? InformativeMovieParser().parse(from: data) {
                informativeMovie.isFavorite = self.favoriteMovies.contains(informativeMovie.movieId)
                completion(informativeMovie)
            } else {
                completion(nil)
            }
            
        }
    }
    
    func fetchMoviesBy(searchStr: String, completion: @escaping ([Movie]?) -> Void) {
        MoviesFetcher().fetch(for: .search(searchStr: searchStr)) { [unowned self] in
            if let data = $0,
               let movies = try? MoviesParser().parse(from: data) {
                
                movies.forEach {
                    if self.favoriteMovies.contains($0.movieId) {
                        $0.isFavorite = true
                    }
                }
                
                completion(movies)
            } else {
                completion(nil)
            }
        }
    }
}
