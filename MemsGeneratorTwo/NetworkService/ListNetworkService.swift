//
//  ListNetworkService.swift
//  MemsGeneratorTwo
//
//  Created by Jura on 08.08.2020.
//  Copyright © 2020 Jura. All rights reserved.
//

import Foundation
class ListNetworkService {
    private init() {}    
    static func getList(url: String, completion: @escaping(ListModel) -> ()) {
        NetworkService.shared.downloadList(urlString: url) { (json) in
            do {
                let response = ListModel(json: json)
                completion(response)
            } 
        }
    }
}