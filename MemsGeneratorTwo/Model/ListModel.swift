//
//  ListMemsModel.swift
//  MemsGeneratorTwo
//
//  Created by Jura on 08.08.2020.
//  Copyright © 2020 Jura. All rights reserved.
//

import Foundation

// MARK: - Model for loading lists

struct ListModel {
    let array: [String]
    init(json: [String]) {
        self.array = json
    }
}
