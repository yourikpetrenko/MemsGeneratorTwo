//
//  ImageModel.swift
//  MemsGeneratorTwo
//
//  Created by Jura on 08.08.2020.
//  Copyright © 2020 Jura. All rights reserved.
//

import Foundation

struct ImageModel {
    let imageData: Data
    init(json: Data) {
        self.imageData = json
    }
}
