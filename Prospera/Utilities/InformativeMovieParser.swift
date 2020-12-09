//
//  InformativeMovieParser.swift
//  Prospera
//
//  Created by Assaf Tayouri on 08/12/2020.
//

import Foundation


// Struct that responsible for parsing movie with extend inforamtion from remote server's data
struct InformativeMovieParser: Parseable {
    typealias T = InformativeMovie
    
    func parse(from data: Data) throws -> InformativeMovie {
        let informativeMovie = try JSONDecoder().decode(InformativeMovie.self, from: data)
        return informativeMovie
    }
}
