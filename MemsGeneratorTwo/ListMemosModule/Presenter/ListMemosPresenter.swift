//
//  ListMemosPresenter.swift
//  MemsGeneratorTwo
//
//  Created by Jura on 12.08.2020.
//  Copyright © 2020 Jura. All rights reserved.
//

import Foundation

protocol ListViewProtocol: class {
    func updateList()
}

protocol ListViewPresenerProtocol: class {
    init(view: ListViewProtocol, networkService: NetworkServiceProtocol)
    func getMems(completion: @escaping(ListModel) -> Void)
    var listMems: [String] {get set}
}

// MARK: - ListPresenter manages logic ListMemsVC

class ListPresenter: ListViewPresenerProtocol {
    weak var view: ListViewProtocol?
    let networkService: NetworkServiceProtocol!
    var listMems = [String]()
    var currentMem = ""
    let urlListMems = "https://ronreiter-meme-generator.p.rapidapi.com/images"
    
    required init(view: ListViewProtocol, networkService: NetworkServiceProtocol) {
        self.view = view
        self.networkService = networkService
        getMems { (json) in
            self.listMems = json.array
            self.view?.updateList()
        }
    }
    
    // MARK: - Networking. Loading list mems

    func getMems(completion: @escaping(ListModel) -> Void) {
        networkService.downloadList(urlString: urlListMems) { json in
                let response = ListModel(json: json)
                completion(response)

        }
    }
}
