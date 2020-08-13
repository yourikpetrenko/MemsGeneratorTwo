//
//  MainPresenter.swift
//  MemsGeneratorTwo
//
//  Created by Jura on 12.08.2020.
//  Copyright © 2020 Jura. All rights reserved.
//

import Foundation

protocol MainViewProtocol: class {
    func selectedMem(currnetMem: String?)
}

protocol MainViewPresenterProtocol: class {
    init(view: MainViewProtocol, networkService: NetworkServiceProtocol, currentMem: String?)
    func generateMem()
}

class MainPresenter: MainViewPresenterProtocol {
    weak var view: MainViewProtocol?
    let networkService: NetworkServiceProtocol!
    var currentMem: String?
    
    required init(view: MainViewProtocol, networkService: NetworkServiceProtocol, currentMem: String?) {
        self.view = view
        self.networkService = networkService
        self.currentMem = currentMem
    }
    
   public func generateMem() {
    self.view?.selectedMem(currnetMem: currentMem)
    }
    
    
}
