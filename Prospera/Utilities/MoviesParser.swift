//
//  MoviesParser.swift
//  Prospera
//
//  Created by Assaf Tayouri on 08/12/2020.
//

import Foundation

struct MoviesParser: Parseable {
    
    private typealias JSONObject = [AnyHashable: Any]
    private typealias JSONArray = [JSONObject]
    
    typealias T = [Movie]
    
    func parse(from data: Data) throws -> [Movie] {
        let dataAsJson = try JSONSerialization.jsonObject(with: data, options: []) as! JSONObject
        let moviesJson = dataAsJson["Search"] as! JSONArray
        let moviesData = try JSONSerialization.data(withJSONObject: moviesJson, options: [])
        return try JSONDecoder().decode([Movie].self, from: moviesData)
    }
    
}
