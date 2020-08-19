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
    func uploadImage(imageData: Data)
}

protocol MainViewPresenterProtocol {
    init(with view: MainViewProtocol, networkService: NetworkServiceProtocol)
    func getFonts(completion: @escaping(ListModel) -> Void)
    func loadingSelectedImage(completion: @escaping(ImageModel) -> Void)
    var arrayFonts: [String] { get set }
    var urlForGenerate: String? { get set }
    var currentMem: String? { get set }
}

// MARK: - MainPresenter manages logic MainVC

class MainPresenter: MainViewPresenterProtocol {
    
    // MARK: - When the user pressed the button, the url comes, and the method is launched to transfer mem to the MainVC
    
    var urlForGenerate: String? {
        didSet {
            generatingMem { (data) in
                let imageData = data.imageData
                self.view?.uploadImage(imageData: imageData)
            }
        }
    }
    
    // MARK: - When the user selected a template to create a meme
    
    var currentMem: String? {
        didSet {
            loadingSelectedImage { (data) in
                let imageData = data.imageData
                self.view?.uploadImage(imageData: imageData)
            }
        }
    }
    
    weak var view: MainViewProtocol?
    let networkService: NetworkServiceProtocol!
    var arrayFonts = [String]()
    required init(with view: MainViewProtocol, networkService: NetworkServiceProtocol) {
        self.view = view
        self.networkService = networkService
        observingSelectedMem()
        waitinguUrl()
        getFonts { (json) in
            self.arrayFonts = json.array
            self.view?.updateList()
        }
    }
    
    // MARK: - Networking. Loading list fonts
    
    func getFonts(completion: @escaping(ListModel) -> Void) {
        let urlFonts = "https://ronreiter-meme-generator.p.rapidapi.com/fonts"
        networkService.downloadList(urlString: urlFonts) { json in
            let response = ListModel(json: json)
            completion(response)
        }
    }
    
    // MARK: - Networking. Loading selected template
    
    func loadingSelectedImage(completion: @escaping(ImageModel) -> Void) {
        let urlImage = "https://ronreiter-meme-generator.p.rapidapi.com/meme?meme=\(currentMem ?? "")&top=%20&bottom=%20"
        //        print(urlImage)
        networkService.downloadImage(urlString: urlImage) { data in
            do {
                let response = ImageModel(json: data)
                completion(response)
            }
        }
    }
    
    // MARK: - Networking. Generating finished mem
    
    func generatingMem(completion: @escaping(ImageModel) -> Void) {
        let doneUrlMem = urlForGenerate ?? ""
        print(doneUrlMem)
        networkService.downloadImage(urlString: doneUrlMem) { data in
            do {
                let response = ImageModel(json: data)
                completion(response)
            }
        }
    }
    
    // MARK: - Observing at selected template
    
    func observingSelectedMem() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotificationOfSelectedMem(notification:)), name: Notification.Name("settingSelectedMem"), object: nil)
    }
    
    @objc func methodOfReceivedNotificationOfSelectedMem(notification: Notification) {
        let mem = notification.object as? String
        self.currentMem = mem ?? ""
    }
    
    // MARK: - Observing at URL, for generating fineshed mem
    
    func waitinguUrl() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotificationOfGenerateURL(notification:)), name: Notification.Name("generatingMem"), object: nil)
    }
    
    @objc func methodOfReceivedNotificationOfGenerateURL(notification: Notification) {
        let generateMem = notification.object as? String
        self.urlForGenerate = generateMem ?? ""
    }
}
