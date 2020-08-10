//
//  ImageNetworkService.swift
//  MemsGeneratorTwo
//
//  Created by Jura on 08.08.2020.
//  Copyright © 2020 Jura. All rights reserved.
//

import Foundation
class ImageNetworkService {
    private init() {}
    static func getList(url: String, completion: @escaping(ImageModel) -> ()) {
        NetworkService.shared.downloadImage(urlString: url) { (response) in
            do {
                let response = ImageModel(json: response)
                completion(response)
            }
        }
    }
}