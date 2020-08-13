//
//  ListMemosPresenter.swift
//  MemsGeneratorTwo
//
//  Created by Jura on 12.08.2020.
//  Copyright © 2020 Jura. All rights reserved.
//

import Foundation

protocol ListViewProtocol: class {
    func secces()
    func failure(error: Error)
}

protocol ListViewPresenerProtocol: class {
    init(view: ListViewProtocol, networkService: NetworkServiceProtocol)
    func getMems()
    var mems: ListModel? {get set}
}

class ListPresenter: ListViewPresenerProtocol {
    weak var view: ListViewProtocol?
    let networkService: NetworkServiceProtocol!
    var mems: ListModel?
    let urlListMems = "https://ronreiter-meme-generator.p.rapidapi.com/images"
    
    required init(view: ListViewProtocol, networkService: NetworkServiceProtocol) {
        self.view = view
        self.networkService = networkService
        getMems()
        print(self.mems)
        print("SRABOTALO")
    }
    
    func getMems() {
        networkService.downloadList(urlString: urlListMems) { [weak self] json in
            guard let self = self else { return }
            DispatchQueue.main.async {
                let response = ListModel(json: json)
                self.mems = response
                
            }
        }
    }
}
