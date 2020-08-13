//
//  ModuleBuilder.swift
//  MemsGeneratorTwo
//
//  Created by Jura on 13.08.2020.
//  Copyright © 2020 Jura. All rights reserved.
//

import UIKit

protocol Builder {
    static func createMainModule(currentMem: String?) -> UIViewController
    static func createListModule() -> UIViewController
}

class ModelBuilder: Builder {
    static func createMainModule(currentMem: String?) -> UIViewController {
        let view = MainVC()
        let networkService = NetworkService()
        let presenter = MainPresenter(view: view, networkService: networkService, currentMem: currentMem)
        view.presenter = presenter
        return view
    }
    
    static func createListModule() -> UIViewController {
        let view = ListMems()
        let networkService = NetworkService()
        let presenter = ListPresenter(view: view, networkService: networkService)
        view.presenter = presenter
        return view
    }
    
}
