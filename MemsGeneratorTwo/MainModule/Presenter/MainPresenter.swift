//
//  MainPresenter.swift
//  MemsGeneratorTwo
//
//  Created by Jura on 12.08.2020.
//  Copyright © 2020 Jura. All rights reserved.
//

import UIKit

protocol MainViewProtocol: class {
    func updateList()
    func uploadImage()
}

protocol MainViewPresenterProtocol {
    init(with view: MainViewProtocol, networkService: NetworkServiceProtocol)
    func getFonts(completion: @escaping(ListModel) -> Void)
    func loadingSelectedImage(urlImage: String, completion: @escaping(ImageModel) -> Void)
    
    var arrayFonts: [String] { get set }
    var urlTop: String? { get set }
    var urlBottom: String? { get set }
    var urlFont: String? { get set }
    var currentMem: String { get set }
}

class MainPresenter: MainViewPresenterProtocol {
    
    weak var view: MainViewProtocol?
    let networkService: NetworkServiceProtocol!
    
    var urlTop: String?
    var urlBottom: String?
    var urlFont: String?
    var currentMem = ""
    var arrayFonts = [String]()
    
    required init(with view: MainViewProtocol, networkService: NetworkServiceProtocol) {
        self.view = view
        self.networkService = networkService
        getFonts { (json) in
            self.arrayFonts = json.array
            self.view?.updateList()
        }
    }
    
    func getFonts(completion: @escaping(ListModel) -> Void) {
        let urlFonts = "https://ronreiter-meme-generator.p.rapidapi.com/fonts"
        networkService.downloadList(urlString: urlFonts) { json in
            let response = ListModel(json: json)
            completion(response)
        }
    }
    
    func loadingSelectedImage(urlImage: String, completion: @escaping(ImageModel) -> Void) {
        networkService.downloadImage(urlString: urlImage) { data in
            let response = ImageModel(json: data)
            completion(response)
        }
    }
}
