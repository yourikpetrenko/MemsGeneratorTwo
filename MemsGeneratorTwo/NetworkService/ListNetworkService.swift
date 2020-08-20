//
//  ListNetworkService.swift
//  MemsGeneratorTwo
//
//  Created by Jura on 08.08.2020.
//  Copyright © 2020 Jura. All rights reserved.
//

import Foundation

protocol ListNetworkServiceProtocol {
    func getList(url: String, completion: @escaping(ListModel) -> ())
}

final class ListNetworkService: ListNetworkServiceProtocol {
    var networkService: NetworkServiceProtocol = NetworkService()
    func getList(url: String, completion: @escaping(ListModel) -> ()) {
        networkService.downloadList(urlString: url) { (json) in
            do {
                let response = ListModel(json: json)
                completion(response)
            } 
        }
    }
}
