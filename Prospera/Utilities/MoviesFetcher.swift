//
//  MoviesFetcher.swift
//  Prospera
//
//  Created by Assaf Tayouri on 08/12/2020.
//

import Foundation
import Alamofire

// Struct that responsible for fetching movies from the remote server
struct MoviesFetcher {
    func fetch(for movieRequestType: MovieRequestType, completion: @escaping (Data?) -> Void) {
        let urlRequest = movieRequestType.request
        
        AF.request(urlRequest).response(queue: DispatchQueue.global(qos: .background)) {
            response in
            switch response.result {
                case .success(let data):
                    if let data = data,
                       let dataJson = try? JSONSerialization.jsonObject(with: data, options: []) as? JSONObject,
                       let responseIndicatorStr = dataJson["Response"].self as? String,
                       let responseIndicator = Bool(responseIndicatorStr.lowercased()),
                       responseIndicator {
                        completion(data)
                    } else {
                        completion(nil)
                    }
                    
                default:
                    completion(nil)
            }
        }
    }
}
