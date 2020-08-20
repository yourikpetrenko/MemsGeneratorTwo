//
//  ImageNetworkService.swift
//  MemsGeneratorTwo
//
//  Created by Jura on 08.08.2020.
//  Copyright © 2020 Jura. All rights reserved.
//

import Foundation

protocol ImageNetworkServiceProtocol {
    func getImage(url: String, completion: @escaping(ImageModel) -> ())
}

final class ImageNetworkService: ImageNetworkServiceProtocol {
    var networkService: NetworkServiceProtocol = NetworkService()
    func getImage(url: String, completion: @escaping(ImageModel) -> ()) {
        networkService.downloadImage(urlString: url) { (response) in
            do {
                let response = ImageModel(json: response)
                completion(response)
            }
        }
    }
}
