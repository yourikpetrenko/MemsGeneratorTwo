//
//  MainPresenter.swift
//  MemsGeneratorTwo
//
//  Created by Jura on 12.08.2020.
//  Copyright © 2020 Jura. All rights reserved.
//

import Foundation

protocol MainViewProtocol: class {
    func updateList()
}

protocol MainViewPresenterProtocol {
    init(with view: MainViewProtocol, networkService: NetworkServiceProtocol)
    func getList()
    var arrayFonts: [String]? { get set }
}

class MainPresenter: MainViewPresenterProtocol {
    weak var view: MainViewProtocol?
    let networkService: NetworkServiceProtocol!
    var arrayFonts: [String]?
    let urlFonts = "https://ronreiter-meme-generator.p.rapidapi.com/fonts"
    
    required init(with view: MainViewProtocol, networkService: NetworkServiceProtocol) {
        print("SRABOTALO")
        self.view = view
        self.networkService = networkService
//        self.getList()
    }
    
    func getList() {
        networkService.downloadList(urlString: urlFonts) { [weak self] json in
            DispatchQueue.main.async {
                self?.arrayFonts = json
                print(json)
            }
        }
    }
}

