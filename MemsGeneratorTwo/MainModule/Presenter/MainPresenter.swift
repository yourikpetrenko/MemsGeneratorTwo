//
//  MainPresenter.swift
//  MemsGeneratorTwo
//
//  Created by Jura on 12.08.2020.
//  Copyright © 2020 Jura. All rights reserved.
//

import UIKit

protocol MainViewProtocol: class {
    func updateList(arrayFonts: [String])
    func uploadImage(image: UIImage)
}

protocol MainViewPresenterProtocol {
    init(with view: MainViewProtocol, networkService: NetworkServiceProtocol)
    func getList(completion: @escaping(ListModel) -> Void)
    func updateData(mem: String)
    
    var arrayFonts: [String] { get set }
    var urlTop: String? { get set }
    var urlBottom: String? { get set }
    var urlFont: String? { get set }
    var currentMem: String { get set }
}

class MainPresenter: MainViewPresenterProtocol {
    weak var view: MainViewProtocol?

    var urlTop: String?
    var urlBottom: String?
    var urlFont: String?
    var currentMem = "" {
        didSet {
            
        }
    }
    let networkService: NetworkServiceProtocol!
    var arrayFonts = [String]()
    let urlFonts = "https://ronreiter-meme-generator.p.rapidapi.com/fonts"

    required init(with view: MainViewProtocol, networkService: NetworkServiceProtocol) {
        print("SRABOTALO")
        self.view = view
        self.networkService = networkService
        self.getList { (json) in
            self.arrayFonts = json.array
            self.view?.updateList(arrayFonts: self.arrayFonts)
        }
    }
    
    func updateData(mem: String) {
        currentMem = mem
    }
    
    func getList(completion: @escaping(ListModel) -> Void) {
        networkService.downloadList(urlString: urlFonts) { json in
            DispatchQueue.main.async {
                let response = ListModel(json: json)
                completion(response)
            }
        }
    }
    
    func loadingSelectedImage(completion: @escaping(UIImage) -> Void) {
        let urlImage = "https://ronreiter-meme-generator.p.rapidapi.com/meme?meme=\(self.currentMem)&top=%20&bottom=%20"
        print(urlImage)
        networkService.downloadImage(urlString: urlImage) { data in
            guard let image = UIImage(data: data) else { return }
            completion(image)
        }
    }
}
