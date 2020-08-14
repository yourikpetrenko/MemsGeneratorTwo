//
//  ModuleBuilder.swift
//  MemsGeneratorTwo
//
//  Created by Jura on 13.08.2020.
//  Copyright © 2020 Jura. All rights reserved.
//

import UIKit

protocol Builder {
     func createMainModule() -> UIViewController
}

class ModelBuilder: Builder {
     func createMainModule() -> UIViewController {
        
        let mainVC = MainVC()
        let navigationController = UINavigationController(rootViewController: mainVC)
        let networkService = NetworkService()
        let presenter = MainPresenter(with: mainVC, networkService: networkService)
        mainVC.presenter = presenter
        return navigationController
    }
}
