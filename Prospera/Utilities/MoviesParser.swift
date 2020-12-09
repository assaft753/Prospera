//
//  MoviesParser.swift
//  Prospera
//
//  Created by Assaf Tayouri on 08/12/2020.
//

import Foundation

// Alias for JSON Object as a Dictionary
typealias JSONObject = [AnyHashable: Any]

// Alias for JSON Array as an Array of dictionaries
typealias JSONArray = [JSONObject]

// Struct that responsible for parsing movies with basic inforamtion from remote server's data
struct MoviesParser: Parseable {
    typealias T = [Movie]
    
    func parse(from data: Data) throws -> [Movie] {
        let dataAsJson = try JSONSerialization.jsonObject(with: data, options: []) as! JSONObject
        let moviesJson = dataAsJson["Search"] as! JSONArray
        let moviesData = try JSONSerialization.data(withJSONObject: moviesJson, options: [])
        return try JSONDecoder().decode([Movie].self, from: moviesData)
    }
    
}
