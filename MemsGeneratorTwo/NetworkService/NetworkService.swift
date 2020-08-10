//
//  NetworkingService.swift
//  MemsGeneratorTwo
//
//  Created by Jura on 04.08.2020.
//  Copyright © 2020 Jura. All rights reserved.
//

import Foundation
import Alamofire

class NetworkService {
    private init() {}
    static let shared = NetworkService()
    func downloadList(urlString: String, completion: @escaping ([String]) -> Void) {
        let headers: HTTPHeaders = [
            "x-rapidapi-host": "ronreiter-meme-generator.p.rapidapi.com",
            "x-rapidapi-key": "593d858ec7msh44787ba9e3aa6aep106925jsne707a7a50200"]
        guard let url = URL(string: urlString) else { return }
        AF.request(url, method: .get, headers: headers).responseJSON { (response) in
            guard let data = response.data else { return }
            do { 
                let array = try JSONSerialization.jsonObject(with: data, options: []) as? [String]
                DispatchQueue.main.async {
                    completion(array ?? [])
                }
            } catch let error {
                print(error)
            }
        }
    }
    
    func downloadImage(urlString: String, completion: @escaping (Data) -> Void) {
        let headers: HTTPHeaders = [
            "x-rapidapi-host": "ronreiter-meme-generator.p.rapidapi.com",
            "x-rapidapi-key": "593d858ec7msh44787ba9e3aa6aep106925jsne707a7a50200"]
        guard let urlString = URL(string: urlString) else { return }
        AF.request(urlString, method: .get, headers: headers).responseJSON { (response) in
            guard let data = response.data else { return }
            DispatchQueue.main.async {
                completion(data)
            }
        }
    }
}
