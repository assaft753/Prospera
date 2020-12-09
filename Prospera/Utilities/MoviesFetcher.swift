//
//  MoviesFetcher.swift
//  Prospera
//
//  Created by Assaf Tayouri on 08/12/2020.
//

import Foundation
import Alamofire

struct MoviesFetcher {
    func fetch(for movieRequestType: MovieRequestType, completion: @escaping ([AnyHashable: Any]) -> Void) {
        let urlRequest = movieRequestType.request
        AF.request(urlRequest).response(queue: DispatchQueue.global(qos: .background)) {
            response in
            var dataDic: [AnyHashable: Any]
            switch response.result {
                case .success(let data):
                    if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [AnyHashable: Any] {
                        dataDic = json
                    } else {
                        dataDic = [:]
                    }
                default:
                    dataDic = [:]
            }
            completion(dataDic)
        }
    }
}
